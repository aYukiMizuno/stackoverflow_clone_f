<template>
  <div>
    <div class="card">
      <div class="card-body">
        <form class="form-group">
          <p class="card-text" style="white-space: pre-wrap;" v-if="!editing">{{ answer.body }}</p>
          <textarea class="card-text form-control" v-else v-model="editingBody"></textarea>
          <div class="card-text">
            <div class="float-left">
              <small class="text-muted">
                {{ answer.userId }} さん / {{ answer.createdAt }}
              </small>
            </div>
            <div class="float-right" v-if="owned">
              <button class="btn btn-sm btn-info" v-if="!editing" v-on:click="startEdit()">
                編集
              </button>
              <button class="btn btn-sm btn-warning" v-if="editing" v-on:click="cancelEdit()">
                取消
              </button>
              <button class="btn btn-sm btn-info" v-if="editing" v-on:click="submitEdit()">
                更新
              </button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Comment from '@/components/Comment';

export default {
  name: 'Answer',
  data(){
    return {
      editing: false,
      editingBody: "",
    };
  },

  components: {
    Comment,
  },

  methods:{
    startEdit(){
      this.editing = true;
      this.editingBody = this.answer.body;
    },
    cancelEdit(){
      this.editing = false;
    },
    submitEdit(){
      this.$store.dispatch('updateAnswer',{
        questionId: this.answer.questionId,
        id: this.answer.id,
        body: this.editingBody
      }).then(()=>{
        this.editing = false;
      });
    }
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
