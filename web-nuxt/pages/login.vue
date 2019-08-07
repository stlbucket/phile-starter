<template>
  <div>
    <v-text-field
      v-model="username"
      label="username"
      placeholder="username"
    ></v-text-field>
    <v-text-field
      v-model="password"
      label="password"
      placeholder="password"
    ></v-text-field>
    <v-btn @click="login">Login</v-btn>
    <hr />
    <h2>Other logins - same password</h2>
    <ul>
      <li>appsuperadmin</li>
      <li>testUser001</li>
    </ul>
  </div>
</template>

<script>
import loginMutation from '@/graphql/mutation/login.graphql'
import currentAppUser from '@/graphql/query/currentAppUser.graphql'

export default {
  name: 'Login',
  components: {},
  data() {
    return {
      username: 'testAdmin001',
      password: 'badpassword'
    }
  },
  computed: {},
  methods: {
    login() {
      const variables = {
        username: this.username,
        password: this.password
      }
      this.$apollo
        .mutate({
          mutation: loginMutation,
          variables: variables
        })
        .then((result) => {
          console.log(result.data)
          this.$apolloHelpers.onLogin(
            result.data.authenticate
              .jwtToken /* if not default you can pass in client as second argument, and you can set custom cookies attributes object as the third argument */
          )
          this.getCurrentAppUserContact()
        })
        .catch((error) => {
          console.log('ERROR', error)
        })
    },
    getCurrentAppUserContact() {
      this.$apollo
        .query({
          query: currentAppUser,
          fetchPolicy: 'network-only',
          variables: {}
        })
        .then((result) => {
          console.log('result', result.data)
          // this.$store.commit('login', {
          //   currentAppUser: result.data.allAppUsers.nodes[0]
          // })
          // this.$router.push({ name: 'home' })
        })
        .catch((error) => {
          console.log('ERROR', error)
        })
    }
  }
}
</script>
