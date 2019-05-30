<template>
  <div>
    <div class="card">
      <div class="card-body">
        <form class="form-group">
          <p
            v-if="!editing"
            class="card-text"
          >
            <pre style="font-family: inherit;">{{ answer.body }}</pre>
          </p>
          <textarea
            v-else
            v-model="editingBody"
            class="card-text form-control"
          />
          <div class="card-text">
            <div class="float-left">
              <PostInfo
                :document="answer"
                :post-type="'durTuser'"
              />
            </div>
            <div
              v-if="own && !editing"
              class="float-right"
            >
              <button
                class="btn btn-sm btn-outline-primary"
                @click="startEdit()"
              >
                編集
              </button>
            </div>
            <div
              v-else-if="own && editing"
              class="float-right"
            >
              <button
                class="btn btn-sm btn-outline-primary"
                @click="cancelEdit()"
              >
                取消
              </button>
              <button
                class="btn btn-sm btn-primary"
                @click="submitEdit()"
              >
                更新
              </button>
            </div>
          </div>
        </form>
      </div>
      <div class="card-footer bg-transparent">
        <div
          v-for="comment in answer.comments"
          id="an-comment-list"
          :key="comment.id"
        >
          <comment
            :comment="comment"
            :documentname="'answer'"
          />
        </div>

        <form
          v-if="isLoggedIn()"
          class="card container"
          @submit.prevent="submit_anComment"
        >
          <div class="card-body">
            <input
              v-model="bodyOfComment"
              type="text"
              class="form-control"
              placeholder="コメントを投稿する"
              minlength="1"
              maxlength="1000"
              required
            >
          </div>
          <div class="card-footer bg-transparent">
            <div class="text-right">
              <button
                class="btn btn-primary btn-sm"
                type="submit"
              >
                投稿
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';
import PostInfo from '@/components/PostInfo';

export default {
  name: 'Answer',

  components: {
    Comment,
    PostInfo,
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
    own() {
      return this.$store.state.id === this.answer.userId;
    },
  },

  methods: {
    startEdit() {
      console.log(this.answer);
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
