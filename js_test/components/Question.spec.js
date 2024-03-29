import assert from 'power-assert';
import Vuex from 'vuex';
import { shallowMount } from '@vue/test-utils';
import '../TestHelper';
import Question from '@/components/Question';
import router from '@/router';

describe('Question', function () {
  const question = {
    id: '5aef02ae36000036000cd039',
    created_at: '2018-05-06T13:27:10+00:00',
    user_id: '5aa2100737000037001811c3',
    title: 'titleX',
    like_voter_ids: [],
    dislike_voter_ids: [],
    comments: [
      {
        user_id: '5aa2100737000037001811c3',
        id: '0GhVJIvT3TUqastruFr9',
        created_at: '2018-05-06T14:00:23+00:00',
        body: 'bodyX',
      },
    ],
    body: 'bodyX',
  };

  let store;


  beforeEach(() => {
    store = new Vuex.Store({
      state: {},
      actions: {},
    });
  });

  it('renders answer body and comment components', () => {
    const wrapper = shallowMount(Question, {
      store,
      router,
      propsData: { question },
    });
    assert(wrapper.contains('.question-title'));
    assert(wrapper.contains('.question-body'));
    assert(wrapper.contains('.comments'));
    assert(wrapper.find('.question-title').text().includes(question.title));
    assert(wrapper.find('.question-body').text().includes(question.body));
  });

  // it('renders comment form', () => {
  //   const wrapper = shallowMount(Question, {
  //     store,
  //     router,
  //     propsData: { question },
  //   });
  //   assert(wrapper.contains('#form-commentQuestionInput'));
  // });
});
