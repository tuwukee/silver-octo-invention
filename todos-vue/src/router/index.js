import Vue from 'vue'
import Router from 'vue-router'
import Sigin from '@/components/Signin'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Sigin',
      component: Sigin
    }
  ]
})
