defmodule StackoverflowCloneF.Controller.Question.CreateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData

  @api_prefix "/v1/question"

  @header %{
    "authorization" => "user_credential"
  }
  @body %{
    "title" => "title ",
    "body"  => "message",
  }

  test "create/1 " <> "success" do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, _) ->
      %Dodai.CreateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)

    res = Req.post_json(@api_prefix, @body, @header)
    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
  end
end
