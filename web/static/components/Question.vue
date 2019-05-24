<template>
  <div>
    <div class="page-title"><h1>{{ question.title }}</h1></div>
    <div class="body">{{ question.body }}</div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Question',
  components: {
    Comment,
  },
  props: {
    question: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
</style>