<template>
  <div>
    <div class="card">
      <div class="card-body">
        <form class="form-group">
          <p
            v-if="!editing"
            class="card-text"
            style="white-space: pre-wrap;"
          >
            {{ answer.body }}
          </p>
          <textarea
            v-else
            v-model="editingBody"
            class="card-text form-control"
          />
          <div class="card-text">
            <div class="float-left">
              <small class="text-muted">
                {{ answer.userId }} さん / {{ answer.createdAt }}
              </small>
            </div>
            <div
              v-if="owned"
              class="float-right"
            >
              <button
                v-if="!editing"
                class="btn btn-sm btn-info"
                @click="startEdit()"
              >
                編集
              </button>
              <button
                v-if="editing"
                class="btn btn-sm btn-warning"
                @click="cancelEdit()"
              >
                取消
              </button>
              <button
                v-if="editing"
                class="btn btn-sm btn-info"
                @click="submitEdit()"
              >
                更新
              </button>
            </div>
          </div>
        </form>
      </div>
      <div
        v-for="comment in answer.comments"
        id="an-comment-list"
        :key="comment.id"
        class="comments"
      >
        <comment
          :comment="comment"
          :documentname="'answer'"
        />
      </div>
      <div id="an-comment-submit">
        <form
          @submit.prevent="submit_anComment"
        >
          <div class="form-group">
            <label for="form-commentAnswerInput">コメント</label>
            <input
              id="form-commentAnswerInput"
              v-model="bodyOfComment"
              class="form-control"
              placeholder="コメント欄"
              type="text"
              minlength="1"
              maxlength="1000"
              required
            >
          </div>
          <button
            class="btn btn-primary"
            type="submit"
          >
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

  components: {
    Comment,
  },

  props: {
    answer: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      editing: false,
      editingBody: '',
      bodyOfComment: '',
    };
  },

  computed: {

    owned() {
      return true;
    },
  },

  methods: {
    startEdit() {
      this.editing = true;
      this.editingBody = this.answer.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    submitEdit() {
      this.$store.dispatch('updateAnswer', {
        questionId: this.answer.questionId,
        id: this.answer.id,
        body: this.editingBody,
      }).then(() => {
        this.editing = false;
      });
    },
    submit_anComment() {
      console.log(this.answer);
      this.$store.dispatch('createAnswerComment', {
        questionId: this.answer.questionId,
        answerId: this.answer.id,
        body: this.bodyOfComment,
      })
        .then(() => {
          this.bodyOfComment = '';
        });
    },
  },
};
</script>

<style scoped>
</style>
