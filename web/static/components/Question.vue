<template>
  <div>
    <h2 class="page-title">
      {{ question.title }}
    </h2>
    <p class="body">
      {{ question.body }}
    </p>
    <div
      v-for="comment in question.comments"
      :key="comment.id"
      class="comments"
    >
      <comment :comment="comment" />
    </div>
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
