<template>
  <div>
      <div class="content-area">
        <div v-if="editing">
        <div class="form-group">
          <label for="form-title">タイトル</label>
          <input
            id="form-title"
            v-model="editingTitle"
            maxlength="100"
            minlength="1"
            class="title-edit form-control"
            type="text"
            required
          >
        </div>
      </div>
      <div v-else>
        <h2 class="page-title"> <!-- TODO: デザインをなんとかする -->
          {{ question.title }}
        </h2>
      </div>
      <div v-if="editing">
        <form
          class="question-form"
          @submit.prevent="update"
        >
          <div class = "form-group">
            <label for="form-body">内容</label>
            <input
              id="form-body"
              v-model="editingBody"
              class="body-edit form-control"
              maxlength="3000"
              minlength="1"
              type="text"
              required
            >
            </div>
              <div class="form-group">
                <button
                  class="btn btn-primary mb-2"
                  type="submit"
                  @click.prevent="submit_updatequestion"
                >
                  保存
                </button>
                <button
                  class="cancel-edit-button btn btn-outline-primary mb-2"
                  type="submit"
                  @click.prevent="cancelEdit"
                >
                  キャンセル
                </button>
              </div>
        </form>
      </div>
      <div v-else>
        <div class="body">
          {{ question.body }}
        </div>
        <div class="additional">
          <span v-if="!editing">
            <button
              type="button"
              class="edit-button btn btn-link"
              @click="startEdit"
            >
              更新
            </button>
          </span>
        </div>
      </div>
    </div>
    
    <div
      v-for="comment in question.comments"
      :key="comment.id"
      class="comments"
    >
      <comment :comment="comment" />
    </div>
    <div>
      <form
        @submit.prevent="submit_postComment"
      >

        <div class="form-group">
          <label for="form-commentQuestionInput">コメント</label>

          <input
            class="form-control"
            id="form-commentQuestionInput"
            v-model="bodyOfComment"
            placeholder="コメント欄"
            type="text"
            minlength="1"
            required
          />
        </div>
        <button class="btn btn-primary" type="submit">
          投稿
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  data(){
    return {
      editing: false,
      editingTitle: '',
      editingBody: '',
      bodyOfComment: '',
    }
  },
  components: {
    Comment,
  },
  methods:{
    startEdit(){
      this.editing = true;
      this.editingTitle = this.question.title;
      this.editingBody = this.question.body;
    },
    cancelEdit(){
      this.editing = false;
    },
    update(){
      this.$emit('update',{title:editingTitle, body: this.editingBody});
      this.editing = false;
    },
    submit_updatequestion(){
      this.$store.dispatch('updateQuestion',{id: this.$route.params.id, title: this.editingTitle, body: this.editingBody});
      this.editing = false;
    },
    submit_postComment(){
      this.$store.dispatch('createQuestionComment',{
        questionId: this.question.id,
        body: this.bodyOfComment
      })
      .then( ()=> {
        // TODO: 
      });
    }
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
</style>
