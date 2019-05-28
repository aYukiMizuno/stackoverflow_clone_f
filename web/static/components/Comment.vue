<template>
  <div class="comment">
    <div v-if="editingQC">
      <div class = "form-comment-group">
        <form
          class="question-comment-form"
        >
          <label for="form-comment-group">コメント</label>
          <input
            id="form-comment-body"
            class="comment-body-edit form-control"
            v-model="editingQCBody"
            maxlength="1000"
            minlength="1"
            type="text"
            required
          >
          <div class="form-comment-group">
            <button
              class="btn btn-primary mb-2"
              type="submit"
              @click.prevent="submit_upqueComment"
            >
              保存
            </button>
            <button
              class="cancel-edit-button btn btn-outline-primary mb-2"
              type="submit"
              @click.prevent="cancelQCEdit"
            >
              キャンセル
            </button>
          </div>
        </form>
        
      </div>
    </div>
    <div v-else>
      <div class="comment-user">
      {{ comment.userId }} さん
      </div>
      <p class="comment-body">
        {{ comment.body }}
      </p>  
      <span v-if="!editingQC">
        <button
          type="button"
          class="qc-edit-button btn btn-link"
          @click.prevent="startQCEdit"
        >
          コメント更新
        </button>
      </span>
        
  </div>
    </div>
    
</template>

<script>
export default {
  name: 'Comment',
  data(){
    return {
      editingQC: false,
      editingQCBody:'', 
    }
  },
  props: {
    comment: {
      type: Object,
      required: true,
    },
    documentname:{
      type: String,
      required: true,
    }
  },
  methods:{
    startQCEdit(){
      this.editingQC = true;
      this.editingQCBody = this.comment.body;
    },
    cancelQCEdit(){
      this.editingQC = false;
    },
    submit_upqueComment(){
      
      if(this.documentname=='question'){
        this.$store.dispatch('updateQuestionComment',{
        questionId: this.$route.params.id, 
        id: this.comment.id,
        body: this.editingQCBody});
      }else{
        this.$store.dispatch('updateAnswerComment',{
        questionId: this.$route.params.id, 
        answerId: this.$parent.answer.id,
        id: this.comment.id,
        body: this.editingQCBody});   
      };
        
      this.editingQC = false;
    },

  },

};
</script>

<style scoped>
</style>
