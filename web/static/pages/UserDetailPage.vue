<template>
  <div>
    <div class="page-title">
      ユーザー詳細
    </div>
    <hr>


    <div class="d-flex flex-row">
      <div
        class=""
        style="width: 360px"
      >
        <div class="icon-wrapper d-flex flex-column justify-content-center img-thumbnail">
          <div class="icon-userface">
            😀
          </div>
        </div>
        <h3 class="break-all">
          <!-- user name -->
        </h3>
        <div class="break-all">
          <small class="">@{{ userId }}</small>
        </div>
      </div>
      <div class="flex-grow-1">
        <div>
          <ul class="nav nav-pills nav-fill nav-lg">
            <li class="nav-item">
              <a
                class="nav-link"
                style="font-size: larger"
                href="#"
                :class="{active: switchList === 0}"
                @click="flipQuestions()"
              >{{ questions.length }}<br>Questions</a>
            </li>
            <li class="nav-item">
              <a
                class="nav-link"
                style="font-size: larger"
                href="#"
                :class="{active: switchList === 1}"
                @click="flipAnswers()"
              >{{ answers.length }}<br>Answers</a>
            </li>
          </ul>

          <div
            v-show="switchList === 0"
            class="question-list list-group"
          >
            <div
              v-for="question in questions"
              :key="question.id"
              class="list-group-item list-group-item-action"
            >
              <div class="question-title">
                <router-link :to="{ name: 'QuestionDetailPage', params: { id: question.id }}">
                  {{ question.title }}
                </router-link>
              </div>
              <div class="additional">
                Posted at {{ question.createdAt }}
              </div>
            </div>
          </div>
          <div
            v-show="switchList === 1"
            class="answer-list list-group"
          >
            <div
              v-for="answer in answers"
              :key="answer.id"
              class="list-group-item list-group-item-action fade-in"
            >
              <div class="answer-body">
                <router-link :to="{ name: 'QuestionDetailPage', params: { id: answer.questionId }}">
                  {{ answer.body }}
                </router-link>
              </div>
              <div class="additional">
                Posted at {{ answer.createdAt }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>


    <hr>
  </div>
</template>

<script>

export default {
  name: 'UserDetailPage',
  data() {
    return {
      switchList: 0,
    };
  },
  computed: {
    userId() {
      return this.$route.params.id;
    },
    questions() {
      return this.sortBy(this.$store.state.questions, 'createdAt').reverse();
    },
    answers() {
      return this.sortBy(this.$store.state.answers, 'createdAt').reverse();
    },
  },
  mounted() {
    this.$store.dispatch('retrieveQuestions', { userId: this.userId });
    this.$store.dispatch('retrieveAnswers', { userId: this.userId });
  },
  methods: {
    flipQuestions() {
      this.switchList = 0;
    },
    flipAnswers() {
      this.switchList = 1;
    },
  },
};
</script>

<style scoped>
.icon-wrapper{
  width: 300px;
  height: 300px
}
.icon-userface{
  text-align: center;
  font-size: 180px;
}
.icon-userface:hover{
  animation: iconanim 0.5s ease 1;
}
.break-all{
  word-break: break-all;
}

.fade-in:hover{
  animation: fade-in 0.5s linear 1;
}

@keyframes iconanim {
    0% {
        transform: scale(0.9);
    }
    100% {
        transform: scale(1);
    }
}
</style>
