<template>
  <div>
    <h2 class="page-title"> <!-- TODO: デザインをなんとかする -->
      {{ question.title }}
    </h2>
    <p class="body">
      {{ question.body }}
    </p>
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
      bodyOfComment: ''
    }
  },
  components: {
    Comment,
  },
  methods:{
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
