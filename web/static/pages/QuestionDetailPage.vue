<template>
  <div>
    <div v-if="hasValidQuestion">
      <question
        :question="question"
        class="question"
        @update="updateQuestion"
      />

      <hr>

      <div
        v-for="answer in answers"
        :key="answer.id"
      >
        <answer :answer="answer" />
      </div>

      <hr>

      <div
        v-if="isLoggedIn()"
      >
        <div class="card">
          <div class="card-body">
            <h3 class="card-title">
              回答を投稿する
            </h3>
            <form
              @submit.prevent="postAnswer"
            >
              <div
                class="form-group"
              >
                <textarea
                  v-model="bodyPostAnswer"
                  class="form-control"
                  rows="5"
                />
              </div>
              <div class="clearfix">
                <input
                  class="btn btn-primary float-right"
                  type="submit"
                >
              </div>
            </form>
          </div>
        </div>
      </div>
      <div v-else>
        <div class="card border-success">
          <div class="card-body">
            <p class="text-center">
              あなたも回答してみませんか :)
            </p>
            <div class="text-center">
              すでにアカウントを持っている方は
              <router-link
                class="login-link"
                to="/login"
              >
                ログイン
              </router-link>
            </div>
          </div>
        </div>
      </div>

      <hr>

      <router-link :to="{ name: 'QuestionListPage'}">
        一覧に戻る
      </router-link>
    </div>
  </div>
</template>


<script>
import Question from '@/components/Question';
import Answer from '@/components/Answer';

export default {
  name: 'QuestionDetailPage',
  components: {
    Question,
    Answer,
  },
  data() {
    return {
      bodyPostAnswer: '',
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },
    question() {
      return this.$store.state.question;
    },
    answers() {
      return this.$store.state.answers;
    },
  },
  mounted() {
    this.retrieveQuestion();
    this.retrieveAnswers();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
    retrieveAnswers() {
      this.$store.dispatch('retrieveAnswers', { questionId: this.$route.params.id });
    },
    updateQuestion({ title, body }) {
      this.$store.dispatch('updateQuestion', { id: this.$route.params.id, title, body });
    },
    postAnswer() {
      this.$store.dispatch('createAnswer', { questionId: this.question.id, body: this.bodyPostAnswer });
      this.bodyPostAnswer = '';
    },
  },
};
</script>

<style scoped>
</style>
