<template>
  <div class="main">
    <div class="card">
      <form class="login-form" @submit.prevent="submit">
        <div>
          <!-- <label>
            Email:
            <input
              v-model="email"
              class="email-edit"
              type="email"
              width="100px"
              required
            >
          </label> -->
          <label for="email2" class="label-font mb-2 mr-sm-2">Email:</label>
          <input 
            type="email" 
            v-model="email"
            class="form-control mb-2 mr-sm-2" 
            id="email2" 
            placeholder="Enter email" 
            name="email"
            required>
        </div>
        <div>
          <!-- <label>Password:
            <input
              v-model="password"
              class="password-edit"
              type="password"
              minlength="8"
              required
            >
          </label> -->
          <label for="pwd2" class="label-font mb-2 mr-sm-2">Password:</label>
          <input 
            type="password"
            v-model="password" 
            class="form-control mb-2 mr-sm-2" 
            id="pwd2" 
            placeholder="Enter password" 
            minlength="8"
            name="pswd"
            required>
        </div>
        
        <div class="form-inline">
          <div class="form-check mb-2 mr-sm-2">
            <label class="label-font form-check-label">
              <input type="checkbox" class="form-check-input" name="remember"> Remember me
            </label>
          </div>  
          <button type="submit" class="btn btn-primary">
            ログイン
          </button>
          <div class="error-message">
            {{ errorMsg }}
        </div>
        </div>
        
      </form>
    </div>
    
    <div class="mainbg">
      <video id="video" poster autoplay muted loop>
        <source src="https://www.access-company.com/wp-content/themes/access_jp/img/top-movie.mp4"
        type="video/mp4">
      </video>
  </div>
  </div>
</template>

<script>
export default {
  name: 'LoginPage',
  data() {
    return {
      email: '',
      password: '',
      errorMsg: '',
    };
  },
  methods: {
    submit() {
      this.$store.dispatch('login', { email: this.email, password: this.password })
        .then(() => {
          this.$router.push({ path: '/' });
        })
        .catch(() => {
          this.errorMsg = 'ログインに失敗しました';
        });
    },
  },
};
</script>

<style scoped>
.main {
  margin: 20% auto auto auto;
  background-color: #f7f7f7;
  width: 500px;
}
.error-message {
  color: red;
}
.login-form {
  position: relative;
  width: 100%;
  height: 100%;
  z-index: 3;
  margin-inline-start: 2mm;
  margin-inline-end: 2mm;
  margin-left: 3mm;
  margin-right: 3mm;
}
.label-font {
  color:aliceblue;
}
.mainbg {
  position: absolute;
  top: 15mm;
  left: 0;
  right:0;
  width: 100%;
  height: 100%;
  height: 100vh;
  overflow: hidden;
  z-index: 1;
}
</style>
