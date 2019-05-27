<template>
  <div>
    <div class="card">
      <div class="card-body">
        <p class="card-text">
          {{ answer.body }}
        </p>
        <div class="card-text">
          <small class="text-muted">{{ answer.userId }} さん / {{ answer.createdAt }}</small>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Answer',
  components: {
    Comment,
  },

  props: {
    answer: {
      type: Object,
      required: true,
    },
  },
};
</script>

<style scoped>
</style>
