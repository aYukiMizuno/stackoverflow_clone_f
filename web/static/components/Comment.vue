<template>
  <div class="comment">
    <div class="comment-user">
      {{ comment.userId }} さん
    </div>
    <p class="comment-body">
      {{ comment.body }}
    </p>
  </div>
</template>

<script>
export default {
  name: 'Comment',
  props: {
    comment: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
</style>
