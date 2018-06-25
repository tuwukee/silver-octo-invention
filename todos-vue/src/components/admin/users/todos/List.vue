<template>
  <div class="users">
    <AppHeader></AppHeader>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>User Todos</h3>
    <br />
    <table class="table">
      <thead>
        <tr>
          <th>ID</th>
          <th>User ID</th>
          <th>Title</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="todo in todos" :key="todo.id" :todo="todo">
          <th>{{ todo.id }}</th>
          <th>{{ todo.user_id }}</th>
          <td>{{ todo.title }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import AppHeader from '@/components/AppHeader'

export default {
  name: 'UserTodosList',
  data () {
    return {
      error: '',
      todos: []
    }
  },
  created () {
    if (this.$store.state.signedIn && this.$store.getters.isAdmin) {
      this.$http.secured.get(`/admin/users/${this.$route.params.id}/todos`)
        .then(response => { this.todos = response.data })
        .catch(error => { this.setError(error, 'Something went wrong') })
    } else {
      this.$router.replace('/')
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    }
  },
  components: { AppHeader }
}
</script>
