<template>
  <div class="users">
    <AppHeader></AppHeader>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>Users</h3>
    <br />
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Email</th>
          <th>Role</th>
          <th v-if="showTodosLink()">Todos</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id" :user="user">
          <th>{{ user.id }}</th>
          <td td v-if="showUsersLink(user)">
            <router-link :to="`/admin/users/${user.id}`">
              {{ user.email }}
            </router-link>
          </td>
          <td td v-else>
            {{ user.email }}
          </td>
          <td>{{ user.role }}</td>
          <td v-if="showTodosLink()">
            <router-link :to="`/admin/users/${user.id}/todos`">
              <i class="fa fa-list-ul"></i>
            </router-link>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import AppHeader from '@/components/AppHeader'

export default {
  name: 'UsersList',
  data () {
    return {
      error: '',
      users: []
    }
  },
  created () {
    if (this.$store.state.signedIn && (this.$store.getters.isAdmin || this.$store.getters.isManager)) {
      this.$http.secured.get('/admin/users')
        .then(response => { this.users = response.data })
        .catch(error => { this.setError(error, 'Something went wrong') })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    showTodosLink () {
      return this.$store.getters.isAdmin
    },
    showUsersLink (user) {
      return this.$store.getters.isAdmin && this.$store.getters.currentUserId !== user.id
    }
  },
  components: { AppHeader }
}
</script>

<style lang="css">
  a i.fa {
    cursor: pointer;
    color: #212529;
  }
</style>
