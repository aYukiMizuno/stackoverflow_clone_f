import assert from 'power-assert';
import Vuex from 'vuex';
import sinon from 'sinon';
import { shallowMount } from '@vue/test-utils';
import '../TestHelper';
import QuestionCreationPage from '@/pages/QuestionCreationPage';
import router from '@/router';

describe('QuestionCreationPage', function () {
  let store;
  let sandbox;
  let createQuestionStub;

  beforeEach(function () {
    sandbox = sinon.createSandbox();
    createQuestionStub = sandbox.stub().callsFake(() => Promise.resolve());
    store = new Vuex.Store({
      state: {
      },
      actions: {
        createQuestion: createQuestionStub,
      },
    });
  });

  afterEach(function () {
    sandbox.restore();
  });

  it('dispatches "createQuestion" when user clicks create button', function (done) {
    const title = 'title';
    const body = 'body';
    sandbox.stub(router, 'push').callsFake(({ path }) => {
      assert(path === '/');
      done();
    });
    const wrapper = shallowMount(QuestionCreationPage, {
      store,
      router,
    });
    wrapper.find('.title-edit').element.value = title;
    wrapper.find('.title-edit').trigger('input');
    wrapper.find('.body-edit').element.value = body;
    wrapper.find('.body-edit').trigger('input');
    wrapper.find('.question-form').trigger('submit');
    const optionArg = createQuestionStub.getCall(0).args[1];
    assert(optionArg.title === title);
    assert(optionArg.body === body);
  });
});
