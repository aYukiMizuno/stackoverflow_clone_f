<template>
  <div class="">
      <img
        src="../imgs/far-thumb-up.png"
        width="20em"
      >{{ countLikeVote}}
      <img
        src="../imgs/far-thumb-down.png"
        width="20em"
      >{{ countDislikeVote}}
  </div>
</template>

<script>
export default {
  name: 'QuestionInfo',
  props: {
    question: {
      type: Object,
      required: true,
    }
  },
  data() {
    return {};
  },
  computed:{
    countLikeVote() {
      return this.question.likeVoterIds.length;
    },
    countDislikeVote() {
      return this.question.dislikeVoterIds.length;
    },
  },
  mounted() {
      
  },
  methods: {
      
  },

};
</script>
