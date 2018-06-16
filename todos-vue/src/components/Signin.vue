<template>
  <form class="px-4 py-3">
    <div class="form-group">
      <label for="exampleDropdownFormEmail1">Email address</label>
      <input v-model="email" type="email" class="form-control" id="exampleDropdownFormEmail1" placeholder="email@example.com">
    </div>
    <div class="form-group">
      <label for="exampleDropdownFormPassword1">Password</label>
      <input v-model="password" type="password" class="form-control" id="exampleDropdownFormPassword1" placeholder="Password">
    </div>
    <button type="submit" class="btn btn-primary" @submit.prevent="signin">Sign in</button>
    <a class="dropdown-item" href="#">New around here? Sign up</a>
    <a class="dropdown-item" href="#">Forgot password?</a>
  </form>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    sigin () {
      console.log(this.email)
      console.log(this.password)
    }
  }
}
</script>
