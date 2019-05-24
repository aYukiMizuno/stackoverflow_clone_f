<template>
  <div>
    <div v-if="hasValidQuestion">
      <question :question="question" />
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
    };
  },
  computed: {
    hasValidQuestion() {
      return !(Object.keys(this.question).length === 0) && this.question.id === this.$route.params.id;
    },
    question() {
      return this.$store.state.question;
    },
  },
  mounted() {
    this.retrieveQuestion();
  },
  methods: {
    retrieveQuestion() {
      this.$store.dispatch('retrieveQuestion', { id: this.$route.params.id });
    },
  },
};
</script>

<style scoped>
</style>
