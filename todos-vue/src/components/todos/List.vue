<template>
  <div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>My todos</h3>
    <ol>
      <li v-for="todo in todos" :key="todo.id">
        {{ todo.title }}
      </li>
    </ol>
  </div>
</template>

<script>
export default {
  name: 'List',
  data () {
    return {
      todos: [],
      error: ''
    }
  },
  created () {
    this.$http.secured.get('/todos')
      .then(request => { this.todos = request.data })
      .catch(error => { this.error = (error.response && error.response.data && error.response.data.error) || '' })
  },
  methods: {

  }
}
</script>
