import axios from 'axios'

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
      'X-CSRF-TOKEN': localStorage.csrf
    }
  }
  return config
})

securedAxiosInstance.interceptors.response.use(null, error => {
  if (error.config && error.response && error.response.status === 401) {
    // In case 401 is caused by expired access cookie - we'll do refresh request
    plainAxiosInstance.post('/refresh', {}, { 'X-CSRF-TOKEN': localStorage.csrf })
      .then(response => {
        localStorage.csrf = response.data.csrf
        localStorage.signedIn = true
        // And after successful refresh - repeat the original request
        return plainAxiosInstance.request(error.response.config)
      }).catch(() => {
        delete localStorage.csrf
        delete localStorage.signedIn
        // redirect to signin in case refresh request fails
        // location.replace('/')
        return Promise.reject(error)
      })
  } else {
    return Promise.reject(error)
  }
})

export { securedAxiosInstance, plainAxiosInstance }
