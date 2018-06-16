<template>
  <form class="form-signin" @submit.prevent="signin">
    <div class="form-group">
      <label for="email">Email address</label>
      <input v-model="email" type="email" class="form-control" id="email" placeholder="email@example.com">
    </div>
    <div class="form-group">
      <label for="password">Password</label>
      <input v-model="password" type="password" class="form-control" id="password" placeholder="Password">
    </div>
    <button type="submit" class="btn btn-primary mb-3">Sign in</button>
    <div>
      <a href="#">Forgot password?</a>
      <a href="#">Sign up</a>
    </div>
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
    signin () {
      this.$http.post('/signin', { user: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(response => this.signinFailed(response))
    },
    signinSuccessful (response) {
      console.log(11234)
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      localStorage.csrf = response.data.csrf
      this.error = false
      this.$router.replace(this.$route.query.redirect || '/todos')
    },
    signinFailed (response) {
      console.log(response)
      this.error = response.data.error
      delete localStorage.csrf
    }
  }
}
</script>

<style lang="css">
.form-signin {
  width: 70%;
  max-width: 500px;
  padding: 10% 15px;
  margin: 0 auto;
}
</style>
