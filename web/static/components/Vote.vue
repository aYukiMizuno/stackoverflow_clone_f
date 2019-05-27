<template>
  <div class="vote">
    <button v-on:click="likeVote()">すき</button>
    <span>{{ countVote }}</span>
    <button v-on:click="dislikeVote()">きらい</button>
  </div>
</template>

<script>
export default {
  name: 'Vote',
  computed:{
    countVote(){
      return this.document.likeVoterIds.length - this.document.dislikeVoterIds.length;
    }
  },
  methods: {
    likeVote(){
      this.$store.dispatch('createQuestionVote',{questionId: this.document.id, voteType: "like_vote"});
    },
    dislikeVote(){
      this.$store.dispatch('createQuestionVote',{questionId: this.document.id, voteType: "dislike_vote"});
    }
  },
  props: {
    document: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
</style>
