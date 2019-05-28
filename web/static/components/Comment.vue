<template>
  <div class="comment container">
    <div class="card">
      <div class="card-body">
        <div
          v-if="!editingQC"
          class=""
        >
          <div class="card-text">
            {{ comment.body }}
          </div>
        </div>
        <div
          v-else
          class=""
        >
          <input
            id="form-comment-body"
            v-model="editingQCBody"
            class="comment-body-edit form-control form-control-sm"
            maxlength="1000"
            minlength="1"
            type="text"
            required
          >
        </div>
        <div class="">
          <div class="float-left">
            <small class="text-muted">{{ comment.userId }} さん / {{ comment.createdAt }}</small>
          </div>
          <div
            v-if="own && !editingQC"
            class="float-right"
          >
            <button
              type="button"
              class="qc-edit-button btn btn-outline-primary btn-sm"
              @click.prevent="startQCEdit"
            >
              更新
            </button>
          </div>
          <div
            v-else-if="own"
            class="float-right"
          >
            <button
              class="btn btn-primary btn-sm"
              type="submit"
              @click.prevent="submit_upqueComment"
            >
              保存
            </button>
            <button
              class="btn btn-outline-primary btn-sm"
              type="submit"
              @click.prevent="cancelQCEdit"
            >
              取消
            </button>
          </div>
          <div class="float:none;" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Comment',
  props: {
    comment: {
      type: Object,
      required: true,
    },
    documentname: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      editingQC: false,
      editingQCBody: '',
    };
  },
  computed: {
    own() {
      return this.$store.state.id === this.comment.userId;
    },
  },
  methods: {
    startQCEdit() {
      this.editingQC = true;
      this.editingQCBody = this.comment.body;
    },
    cancelQCEdit() {
      this.editingQC = false;
    },
    submit_upqueComment() {
      if (this.documentname === 'question') {
        this.$store.dispatch('updateQuestionComment', {
          questionId: this.$route.params.id,
          id: this.comment.id,
          body: this.editingQCBody,
        });
      } else {
        this.$store.dispatch('updateAnswerComment', {
          questionId: this.$route.params.id,
          answerId: this.$parent.answer.id,
          id: this.comment.id,
          body: this.editingQCBody,
        });
      }

      this.editingQC = false;
    },

  },

};
</script>

<style scoped>
.comment{
  margin-bottom: 20px;
}
</style>
