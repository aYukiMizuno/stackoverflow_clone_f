defmodule StackoverflowCloneF.Controller.Answer.CreateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData
  alias StackoverflowCloneF.TestData.AnswerData

  @api_prefix "/v1/answer"

  @header %{
    "authorization" => "user_credential"
  }

  test "create/1 " <> "success" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}

        %Dodai.CreateDedicatedDataEntityRequest{} ->
          %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"],
      "body"        => AnswerData.dodai()["data"]["body"],
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 200
    assert Poison.decode!(res.body) == AnswerData.gear()
  end


  test "create/1 " <> "question not found" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.ResourceNotFound{}

        %Dodai.CreateDedicatedDataEntityRequest{} ->
          %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"] <> "000",
      "body"        => AnswerData.dodai()["data"]["body"],
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 404
  end


  test "create/1 " <> "invalid request body (empty)" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}

        %Dodai.CreateDedicatedDataEntityRequest{} ->
          %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"],
      "body"        => "",
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 400
  end


  test "create/1 " <> "invalid request body (3001 chars)" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}

        %Dodai.CreateDedicatedDataEntityRequest{} ->
          %Dodai.CreateDedicatedDataEntitySuccess{body: AnswerData.dodai()}
      end
    end)

    body = %{
      "question_id" => AnswerData.dodai()["data"]["question_id"],
      "body"        => String.duplicate("a", 3001),
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 400
  end

end
