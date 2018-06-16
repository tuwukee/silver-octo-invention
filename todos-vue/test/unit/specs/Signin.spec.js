import Vue from 'vue'
import Signin from '@/components/Signin'

describe('Signin.vue', () => {
  it('should render correct contents', () => {
    const Constructor = Vue.extend(Signin)
    const vm = new Constructor().$mount()
    expect(vm.$el.querySelector('form a')[0].textContent)
      .to.equal('New around here? Sign up')
  })
})
