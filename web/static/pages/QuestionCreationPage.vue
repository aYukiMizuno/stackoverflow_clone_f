<template>
  <div>
    <div class="page-title">
      質問を投稿する
    </div>
    <form
      class="question-form"
      @submit.prevent="submit"
    >
      <div class="form-group">
        <label for="form-title">タイトル</label>
        <input
          id="form-title"
          v-model="title"
          class="title-edit form-control"
          type="text"
          minlength="1"
          :maxlength="titleMaxLength"
          required 
        >
        <small
          id="form-titlecounter"
          class="form-text text-muted text-right">
          {{title.length}}/{{titleMaxLength}}
        </small>
      </div>
      <div class="form-group">
        <label for="form-body">内容</label>
        <textarea
          id="form-body" 
          v-model="body"
          class="body-edit form-control"
          minlength="1"
          :maxlength="bodyMaxLength"
          required
        />
        <small
          id="form-bodycounter"
          class="form-text text-muted text-right">
          {{this.body.length}}/{{bodyMaxLength}}
        </small>
      </div>
      <div class="form-group">
        <button
          class="btn btn-primary mb-2"
          type="submit"
        >
          投稿
        </button>
      </div>
    </form>
    <hr>
    <router-link :to="{name: 'QuestionListPage'}">
      一覧に戻る
    </router-link>
  </div>
</template>

<script>
export default {
  name: 'QuestionCreationPage',
  data(){
    return{
      title: '',
      body: '',
    };
  },
  methods: {
    submit(){
      this.$store.dispatch('createQuestion',{title: this.title, body: this.body})
      .then( ()=> {
        this.$router.push({path:'/question'});
      });
    },
  },
};
</script>

<style scoped>
.author-edit {
  height: 140px;
}
</style>
