import Vue from 'vue'
import Router from 'vue-router'
import Signin from '@/components/Signin'
import Signup from '@/components/Signup'
import ForgotPassword from '@/components/ForgotPassword'
import ResetPassword from '@/components/ResetPassword'
import TodosList from '@/components/todos/List'
import UsersList from '@/components/admin/users/List'
import UserEdit from '@/components/admin/users/Edit'
import UserTodosList from '@/components/admin/users/todos/List'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/todos',
      name: 'List',
      component: TodosList
    },
    {
      path: '/forgot_password',
      name: 'ForgotPassword',
      component: ForgotPassword
    },
    {
      path: '/password_resets/:token',
      name: 'ResetPassword',
      component: ResetPassword
    },
    {
      path: '/admin/users',
      name: 'UsersList',
      component: UsersList
    },
    {
      path: '/admin/users/:id/todos',
      name: 'UserTodosList',
      component: UserTodosList
    },
    {
      path: '/admin/users/:id',
      name: 'UserEdit',
      component: UserEdit
    }
  ]
})
