<template>
  <div class="vote">
    <button @click="likeVote()">
      すき
    </button>
    <span>{{ countVote }}</span>
    <button @click="dislikeVote()">
      きらい
    </button>
  </div>
</template>

<script>
export default {
  name: 'Vote',
  props: {
    document: {
      type: Object,
      required: true,
    },
  },
  computed: {
    countVote() {
      return this.document.likeVoterIds.length - this.document.dislikeVoterIds.length;
    },
  },
  methods: {
    likeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.document.id, voteType: 'like_vote' });
    },
    dislikeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.document.id, voteType: 'dislike_vote' });
    },
  },
};
</script>

<style scoped>
</style>
