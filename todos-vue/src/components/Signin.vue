<template>
  <form class="form-app form-signin" @submit.prevent="signin">
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
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
      <router-link to="/signup">Sign up</router-link>
      <br />
      <router-link to="/forgot_password">Forgot Password</router-link>
    </div>
  </form>
</template>

<script>
export default {
  name: 'Signin',
  data () {
    return {
      email: '',
      password: '',
      error: ''
    }
  },
  created () {
    this.checkSignedIn()
  },
  updated () {
    this.checkSignedIn()
  },
  methods: {
    signin () {
      this.$http.plain.post('/signin', { email: this.email, password: this.password })
        .then(response => this.signinSuccessful(response))
        .catch(error => this.signinFailed(error))
    },
    signinSuccessful (response) {
      if (!response.data.csrf) {
        this.signinFailed(response)
        return
      }
      this.$http.plain.get('/me')
        .then(meResponse => {
          this.$store.commit('setCurrentUser', { currentUser: meResponse.data, csrf: response.data.csrf })
          this.error = ''
          this.$router.replace('/todos')
        })
        .catch(error => this.signinFailed(error))
    },
    signinFailed (error) {
      this.error = (error.response && error.response.data && error.response.data.error) || ''
      this.$store.commit('unsetCurrentUser')
    },
    checkSignedIn () {
      if (this.$store.state.signedIn) {
        this.$router.replace('/todos')
      }
    }
  }
}
</script>
