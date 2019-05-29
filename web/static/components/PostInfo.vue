<template>
    <div class="additional">
      <span v-if="postCreatedTime">Posted at: {{this.document.createdAt | moment}}</span>
      <span v-else>Posted at: {{this.document.createdAt | submitDur}}</span>
      <span v-show="!isOwner">
        | by <router-link :to="{ name: 'UserDetailPage', params: { id: this.document.userId }}">
          {{ this.document.userId }}
        </router-link>
      </span>
    </div>
</template>

<script>
import moment from 'moment';
export default {
  name: 'PostInfo',
  filters: {
    moment: function (date) {
        return moment(date).format('YYYY/MM/DD HH:mm');
    },
    submitDur(data){
      return moment(data).fromNow();
    },
  },
  props: {
    document: {
      type: Object,
      required: true,
    },
    postType: {
      type: String,
      required: true,
    }
  },
  data() {
    return{
      isOwner: false,
      postCreatedTime: false,
    };
  },
  mounted(){
    this.checkOwner();
    this.checkPostType();
  },
  methods: {
    checkOwner(){
      // console.log(this.$store.state.id)
      if (this.document.userId==this.$store.state.id){
        this.isOwner = true;
      }else{
        this.isOwner = false;
      }
      
    },
    checkPostType(){
      // console.log(this.postType);
      if(this.postType=='createTUser'){
        this.postCreatedTime = true;
      }else{
        this.postCreatedTime = false;
      }
    }
  }

}
</script>