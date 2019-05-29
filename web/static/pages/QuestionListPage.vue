<template>
  <div>
    <div class="page-title">
      質問を見る
    </div>
    <div>
      <router-link to="question/create">
        質問する
      </router-link>
    </div>
    <hr>
    <div
      v-for="question in paginatedQuestions"
      :key="question.id"
    >
      <h5 class="title">
        <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
          {{ question.title }}
        </router-link>
      </h5>
      <div class="additional">
        <PostInfo :document="question" :postType="'createTUser'" />
        <!-- Posted at {{ question.createdAt | moment }}
        by <router-link :to="{ name: 'UserDetailPage', params: { id: question.userId }}">
          {{ question.userId }}
        </router-link> -->
      </div>
      <hr>
    </div>
    <div>
      <nav aria-label="Page navigation example">
        <ul class="pagination">
          <li
            v-for="i in maxPaginationIndex"
            :key="i"
            class="page-item"
            :class="{ active: (i-1 === page) }"
          >
            <a
              class="page-link"
              href="#"
              @click="paginate(i)"
            >
              {{ i }}
            </a>
          </li>
        </ul>
      </nav>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import PostInfo from '@/components/PostInfo';

export default {
  name: 'QuestionListPage',
  filters: {
    moment: function (date) {
        return moment(date).format('YYYY/MM/DD HH:mm');
    },
    submitDur(data){
      return moment(data).fromNow();
    },
  },
  components:{
    PostInfo,
  },
  data() {
    return {
      page: 0, // 今のページ番号 0-indexed
      perQuestions: 10, // 1ページ辺りのページ数
    };
  },
  computed: {
    // 全ての質問データ
    questions() {
      return this.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
    // 全ての質問データの個数
    lengthOfQuestions() {
      return this.questions.length;
    },
    // pageで指定された、今のページに表示する質問データ
    paginatedQuestions() {
      const pq = this.perQuestions;
      return this.questions.slice(
        this.page * pq,
        this.page * pq + pq,
      );
    },
    // 最大のページ番号
    maxPaginationIndex() {
      return Math.ceil(this.lengthOfQuestions / this.perQuestions);
    },
  },
  mounted() {
    this.retrieveQuestions();
  },
  methods: {
    retrieveQuestions() {
      this.$store.dispatch('retrieveQuestions');
    },
    paginate(id) {
      this.page = id - 1;
    },
  },
};
</script>

<style scoped>
.title {
  text-overflow: ellipsis;
  overflow: hidden;
}
</style>
