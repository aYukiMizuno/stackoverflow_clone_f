<template>
  <div class="footer">
    <button
      type="button"
      class="btn btn-outline-light text-dark"
      data-toggle="tooltip"
      data-placement="bottom"
      title="いいね"
      @click="likeVote()"
    >
      <img
        v-if="votedlike"
        src="../imgs/fas-thumb-up.png"
        width="20em"
      >
      <img
        v-else
        src="../imgs/far-thumb-up.png"
        width="20em"
      >  {{ countLikeVote }}
    </button>
    <button
      type="button"
      class="btn btn-outline-light text-dark"
      data-toggle="tooltip"
      data-placement="bottom"
      title="よくない"
      @click="dislikeVote()"
    >
      <img
        v-if="voteddislike"
        src="../imgs/fas-thumbs-down.png"
        width="25em"
      >
      <img
        v-else
        src="../imgs/far-thumbs-down.png"
        width="20em"
      >  {{ countDislikeVote }}
    </button>

    <!-- <span>{{ countVote }}</span> -->
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
  data() {
    return {
      votedlike: false,
      voteddislike: false,
    };
  },
  computed: {
    isLikeVoted() {
      return this.document.likeVoterIds.indexOf(this.$store.state.id) >= 0;
    },
    isDislikeVoted() {
      return this.document.dislikeVoterIds.indexOf(this.$store.state.id) >= 0;
    },
    countVote() {
      return this.document.likeVoterIds.length - this.document.dislikeVoterIds.length;
    },
    countLikeVote() {
      // console.log(this.document.likeVoterIds.indexOf(this.$store.state.id));
      return this.document.likeVoterIds.length;
    },
    countDislikeVote() {
      // console.log(this.document.dislikeVoterIds.indexOf(this.$store.state.id));
      return this.document.dislikeVoterIds.length;
    },
  },
  mounted() {
    this.updateVote();
  },
  methods: {
    likeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.document.id, voteType: 'like_vote' })
        .then(() => {
          this.updateVote();
        });
    },
    dislikeVote() {
      this.$store.dispatch('createQuestionVote', { questionId: this.document.id, voteType: 'dislike_vote' })
        .then(() => {
          this.updateVote();
        });
    },
    updateVote() {
      this.voteddislike = this.isDislikeVoted;
      this.votedlike = this.isLikeVoted;
    },
  },
};

</script>

<style scoped>
</style>
