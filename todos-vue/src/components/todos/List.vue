<template>
  <div>
    <div class="alert alert-danger" v-if="error">{{ error }}</div>
    <h3>Todos</h3>
    <input class="form-control"
      autofocus autocomplete="off"
      placeholder="What needs to be done?"
      v-model="newTodo"
      @keyup.enter="addTodo" />
    <br />
    <ul class="list-group">
      <li class="list-group-item" v-for="todo in todos" :key="todo.id" :todo="todo">
        <div v-show="todo != editedTodo">
          <label @dblclick="editTodo(todo)">{{ todo.title }}</label>
          <button class="btn btn-danger btn-xs float-right" @click="removeTodo(todo)">x</button>
        </div>
        <div v-show="todo == editedTodo">
          <input class="form-control"
            v-todo-focus
            @blur="updateTodo(todo)"
            @keyup.enter="updateTodo(todo)"
            v-model="todo.title"
          />
        </div>
      </li>
    </ul>
  </div>
</template>

<script>
export default {
  name: 'List',
  data () {
    return {
      todos: [],
      newTodo: [],
      error: '',
      editedTodo: ''
    }
  },
  created () {
    if (!localStorage.signedIn) {
      this.$router.replace('/')
    } else {
      this.$http.secured.get('/todos')
        .then(response => { this.todos = response.data })
        .catch(error => {  this.setError('Something went wrong') })
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addTodo () {
      const value = this.newTodo && this.newTodo.trim()
      if (!value) {
        return
      }
      this.$http.secured.post('/todos', { todo: { title: this.newTodo } })
        .then(response => {
          this.todos.push(response.data)
          this.newTodo = ''
        })
        .catch(error => {
          this.error = this.setError(error, 'Cannot create todo')
        })
    },
    removeTodo (todo) {
      this.$http.secured.delete(`/todos/${todo.id}`)
        .then(response => {
          this.todos.splice(this.todos.indexOf(todo), 1)
        })
        .catch(error => {
          this.setError(error, 'Cannot delete todo')
        })
    },
    editTodo (todo) {
      this.editedTodo = todo
    },
    updateTodo (todo) {
      this.editedTodo = ''
      this.$http.secured.patch(`/todos/${todo.id}`, { todo: { title: todo.title } })
        .catch(error => {
          this.setError(error, 'Cannot update todo')
        })
    }
  },
  directives: {
    'todo-focus': function (el) {
      el.focus()
    }
  }
}
</script>

