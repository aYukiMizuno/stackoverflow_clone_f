<template>
  <nav class="navbar bg-dark navbar-dark">
    <router-link
      class="navbar-brand brand-font"
      to="/"
    >
      StackoverFlowClone
    </router-link>
    <div class="form-inline my-2 my-lg-0">
      <div class="navbar-text">
        <router-link
          v-if="isLoggedIn()"
          :to="{ name: 'UserDetailPage', params: { id: myId() }}"
        >
          <i class="fas fa-user" />
        </router-link>
      </div>
      <div class="navbar-text">
        <a
          v-if="isLoggedIn()"
          class="logout-link"
          href=""
          @click.prevent="logout"
        >
          <i class="fas fa-sign-out-alt" />
        </a>
        <span v-else><router-link
          class="login-link"
          to="/login"
        >ログイン</router-link></span>
      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: 'Header',
  methods: {
    logout() {
      this.$emit('logout');
    },
  },
};
</script>

<style scoped>
.navbar-text {
  margin: 0 10px;
}
.navbar-brand::before {
  vertical-align: middle;
  content: url("../imgs/icon.png");
}
.brand-font{
  font-family:Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
  font-size: 6mm
}
</style>
