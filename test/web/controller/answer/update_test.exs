defmodule StackoverflowCloneF.Controller.Answer.UpdateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData
  alias StackoverflowCloneF.TestData.AnswerData

  @api_prefix "/v1/answer/answer_id"

  @header %{
    "authorization" => "user_credential"
  }

  test "update/1 " <> "success" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: AnswerData.dodai()}

        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"],
      "body"        => AnswerData.dodai()["data"]["body"],
    }

    res = Req.put_json(@api_prefix, body, @header)

    assert res.status               == 200
    assert Poison.decode!(res.body) == AnswerData.gear()
  end


  test "update/1 " <> "invalid request body (empty)" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}

        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"],
      "body"        => "",
    }

    res = Req.put_json(@api_prefix, body, @header)

    assert res.status == 400
  end


  test "update/1 " <> "invalid request body (3001 chars)" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}

        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"],
      "body"        => String.duplicate("a", 3001),
    }

    res = Req.put_json(@api_prefix, body, @header)

    assert res.status == 400
  end
end
