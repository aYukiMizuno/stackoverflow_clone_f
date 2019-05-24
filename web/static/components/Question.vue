<template>
  <div>
    <h2 class="page-title">
      {{ question.title }}
    </h2>
    <p class="body">
      {{ question.body }}
    </p>
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
