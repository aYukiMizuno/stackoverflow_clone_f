defmodule StackoverflowCloneF.Controller.Question.UpdateTest do
  use StackoverflowCloneF.CommonCase

  @api_prefix "/v1/question/question_id"
  @header     %{}
  @body       %{"title" => "new title", "body" => "new body",}

  test "update/1 " do

    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} = retrieve_req ->
          # retrieve_reqについて必要に応じてassertする
          assert retrieve_req.id == "question_id"
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: StackoverflowCloneF.TestData.QuestionData.dodai()}

        %Dodai.UpdateDedicatedDataEntityRequest{}   = update_req   ->
          # update_reqについての必要に応じてassertする
          assert update_req.body == %Dodai.UpdateDedicatedDataEntityRequestBody{
            data: %{"$set" => %{"title" => "new title", "body" => "new body",}}
          }
          %Dodai.UpdateDedicatedDataEntitySuccess{body: StackoverflowCloneF.TestData.QuestionData.dodai()}
      end
    end)

    res = Req.put_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == StackoverflowCloneF.TestData.QuestionData.gear()

  end
end
