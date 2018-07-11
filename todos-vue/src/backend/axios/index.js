import axios from 'axios'
import { store } from './../../store'

const API_URL = 'http://localhost:3000'

const securedAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

const plainAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

securedAxiosInstance.interceptors.request.use(config => {
  const method = config.method.toUpperCase()
  if (method !== 'OPTIONS' && method !== 'GET') {
    config.headers = {
      ...config.headers,
      'X-CSRF-TOKEN': store.state.csrf
    }
  }
  return config
})

securedAxiosInstance.interceptors.response.use(null, error => {
  if (error.response && error.response.config && error.response.status === 401) {
    // In case 401 is caused by expired access cookie - we'll do refresh request
    return plainAxiosInstance.post('/refresh', {}, { headers: { 'X-CSRF-TOKEN': store.state.csrf } })
      .then(response => {
        plainAxiosInstance.get('/me')
          .then(meResponse => store.commit('setCurrentUser', { currentUser: meResponse.data, csrf: response.data.csrf }))
        // And after successful refresh - repeat the original request
        let retryConfig = error.response.config
        retryConfig.headers['X-CSRF-TOKEN'] = response.data.csrf
        return plainAxiosInstance.request(retryConfig)
      }).catch(error => {
        store.commit('unsetCurrentUser')
        // redirect to signin in case refresh request fails
        location.replace('/')
        return Promise.reject(error)
      })
  } else {
    return Promise.reject(error)
  }
})

export { securedAxiosInstance, plainAxiosInstance }
