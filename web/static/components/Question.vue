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
        <h2
          class="question-title"
          style="margin-block-end: 0em;"
        >
          {{ question.title }}
        </h2>
      </div>
      <div v-if="editing">
        <form
          class="question-form"
          @submit.prevent="update"
        >
          <div class="form-group">
            <label for="form-body">内容</label>
            <!-- <input
              id="form-body"
              v-model="editingBody"
              class="body-edit form-control"
              maxlength="3000"
              minlength="1"
              type="text"
              required
            > -->
            <textarea
              id="from-body"
              v-model="editingBody"
              placeholder="質疑内容を入力する"
              class="body-edit form-control"
              maxlength="3000"
              minlength="1"
              type="text"
              required
            />
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
        <hr>
        <div>
          <div class="div_float text-dark">
            <button
              v-show="isOwner"
              type="button"
              class="cell btn btn-link text-dark"
              @click="startEdit"
            >
              <a
                data-toggle="tooltip"
                data-placement="left"
                title="質問更新"
              >
                <i
                  class="far fa-edit"
                  style="font-size:24px"
                />
              </a>
            </button>
            <p class="cell question-body">
              <pre style="font-family: inherit;">{{ question.body }}</pre>
            </p>
          </div>
        </div>

        <div class="additional text-right">
          <PostInfo
            :document="question"
            :post-type="'durTuser'"
          />
          <!-- Posted at {{ question.createdAt | submitDur }}
          <span v-show="!isOwner">
            by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
              {{ question.userId }}
            </router-link>
          </span> -->
        </div>
      </div>
      <div class="additional">
        <vote
          :document="question"
          :disabled="!isLoggedIn()"
        />
      </div>
    </div>
    <transition-group name="fade">
      <div
        v-for="comment in question.comments"
        :key="comment.id"
        class="comments"
        style="margin-block-start: 1em;"
      >
        <comment
          :comment="comment"
          :documentname="'question'"
        />
      </div>
    </transition-group>
    <div>
      <form
        v-if="isLoggedIn()"
        @submit.prevent="submit_postComment"
      >
        <div class="form-group">
          <label for="form-commentQuestionInput">コメント</label>

          <input
            id="form-commentQuestionInput"
            v-model="bodyOfComment"
            class="form-control"
            placeholder="コメント欄"
            type="text"
            minlength="1"
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
</template>

<script>
import Comment from '@/components/Comment';
import Vote from '@/components/Vote';
import PostInfo from '@/components/PostInfo';

export default {
  name: 'Question',
  components: {
    Comment,
    Vote,
    PostInfo,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      editing: false,
      editingTitle: '',
      editingBody: '',
      bodyOfComment: '',
      isOwner: false,
    };
  },
  mounted() {
    this.checkOwner();
  },

  methods: {
    startEdit() {
      this.editing = true;
      this.editingTitle = this.question.title;
      this.editingBody = this.question.body;
    },
    cancelEdit() {
      this.editing = false;
    },
    update() {
      this.$emit('update', { title: this.editingTitle, body: this.editingBody });
      this.editing = false;
    },
    submit_updatequestion() {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title: this.editingTitle, body: this.editingBody });
      this.editing = false;
    },
    submit_postComment() {
      this.$store.dispatch('createQuestionComment', {
        questionId: this.question.id,
        body: this.bodyOfComment,
      })
        .then(() => {
        // TODO:
          this.bodyOfComment = '';
        });
    },
    checkOwner() {
      if (this.question.userId === this.$store.state.id) {
        this.isOwner = true;
      } else {
        this.isOwner = false;
      }
    },
  },
};
</script>

<style scoped>
p {
    word-spacing: 0.06em;
}
.question-title {
    display: block;
    margin-block-start: 1em;
    margin-block-end: 1em;
    margin-inline-start: 0px;
    margin-inline-end: 0px;
    font-size:8mm;
}

.question-body{
  display: block;
  font-size:5mm;
  margin-top: 3mm;
  margin-left:3mm;
  margin-bottom:3mm;
}

.div_float {
  content:'';
  display:table;
  clear:both;
}
.div_float .cell {
  float: left;
}
</style>
