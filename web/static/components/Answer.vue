<template>
  <div>
    <div class="card">
      <div class="card-body">
        <p class="card-text">
          {{ answer.body }}
        </p>
        <div class="card-text">
          <div class="float-left">
            <small class="text-muted">
              {{ answer.userId }} さん / {{ answer.createdAt }}
            </small>
          </div>
          <div class="float-right" v-if="owned">
            <button class="btn btn-sm btn-info">
              編集
            </button>
          </div>
        </div>
      </div>
      <div
        id="an-comment-list"
        v-for="comment in answer.comments"
        :key="comment.id"
        class="comments"
      >
        <comment :comment="comment" :documentname = "'answer'"/>
      </div>
      <div id="an-comment-submit">
        <form
          @submit.prevent="submit_anComment"
        >
          <div class="form-group">
            <label for="form-commentAnswerInput">コメント</label>
            <input
              class="form-control"
              id="form-commentAnswerInput"
              v-model="bodyOfComment"
              placeholder="コメント欄"
              type="text"
              minlength="1"
              maxlength="1000"
              required
            />
          </div>
          <button class="btn btn-primary" type="submit">
            投稿
          </button>
        </form> 
      </div>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Answer',
  data(){
    return{
      bodyOfComment:''
    }
  },

  components: {
    Comment,
  },

  computed:{

    owned(){
      return true;
    }
  },

  props: {
    answer: {
      type: Object,
      required: true,
    },
  },

  methods:{
    submit_anComment(){
      console.log(this.answer);
      this.$store.dispatch('createAnswerComment',{
        questionId: this.answer.questionId, 
        answerId: this.answer.id, 
        body: this.bodyOfComment
      })
      .then(()=>{
        this.bodyOfComment='';
      });

    },
  }
};
</script>

<style scoped>
</style>
