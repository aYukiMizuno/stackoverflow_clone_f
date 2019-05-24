import assert from 'power-assert';
import Vuex from 'vuex';
import { shallowMount } from '@vue/test-utils';
import '../TestHelper';
import Comment from '@/components/Comment';
import router from '@/router';

describe('Comment', function () {
  const comment = {
    userId: '5aa2100737000037001811c3',
    id: '0GhVJIvT3TUqastruFr9',
    createdAt: '2018-05-06T14:00:23+00:00',
    body: 'bodyX',
  };

  let store;


  beforeEach(() => {
    store = new Vuex.Store({
      state: {},
      actions: {},
    });
  });

  it('renders user_id and body', () => {
    const wrapper = shallowMount(Comment, {
      store,
      router,
      propsData: { comment },
    });
    assert(wrapper.find('.comment-user').text().includes(comment.userId));
    assert(wrapper.find('.comment-body').text().includes(comment.body));
  });
});
