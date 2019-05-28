<template>
  <div>
    <div class="card">
      <div class="card-body">
        <p class="card-text">
          {{ answer.body }}
        </p>
        <div class="card-text">
          <div class="float-left">
            <small class="text-muted">
              {{ answer.userId }} さん / {{ answer.createdAt }}
            </small>
          </div>
          <div class="float-right" v-if="owned">
            <button class="btn btn-sm btn-info">
              編集
            </button>
          </div>
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

  computed:{

    owned(){
      return true;
    }
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
