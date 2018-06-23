<template>
  <nav class="navbar rounded">
    <ul class="navbar ml-auto">
      <li class="nav-item">
        <a class="nav-link" v-if="showAdmin">Admin</a>
      </li>
      <li class="nav-item sign-out">
        <a class="nav-link" @click="signOut">Sign out</a>
      </li>
    </ul>
  </nav>
</template>

<script>
  export default {
    name: 'AppHeader',
    methods: {
      setError (error, text) {
        this.error = (error.response && error.response.data && error.response.data.error) || text
      },
      signOut () {
        this.$http.secured.delete('/signin')
          .then(response => {
            this.$store.commit('unsetCurrentUser')
            this.$router.replace('/')
          })
          .catch(error => this.setError(error, 'Cannot sign out'))
      },
      showAdmin () {
        return this.$store.state.currentUser.role === 'admin' ||
          this.$store.state.currentUser.role === 'manager'
      }
    }
  }
</script>

<style lang="css">
  .navbar {
    padding-right: 0;
  }
  .navbar a {
    cursor: pointer;
  }
  .navbar ul {
    list-style: none;
  }
  .navbar .sign-out {
    padding-right: 0;
  }
</style>
