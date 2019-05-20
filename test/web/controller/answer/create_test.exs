defmodule StackoverflowCloneF.Controller.Answer.CreateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData

  @api_prefix "/v1/answer"

  @header %{
    "authorization" => "user_credential"
  }

  @dodai %{
    "_id" => "5cde5fbde515145ec918ade2",
    "createdAt" => "2019-05-17T07:16:13+00:00",
    "data" => %{
      "body" => "body",
      "comments" => [],
      "question_id" => "question_id",
      "user_id" => "user_id"
    },
    "owner" => "user_id",
    "sections" => [],
    "updatedAt" => "2019-05-17T07:16:13+00:00",
    "version" => 0
  }

  @gear Map.merge(@dodai["data"], %{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})

  test "create/1 " <> "success" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}

        %Dodai.CreateDedicatedDataEntityRequest{} ->
          %Dodai.CreateDedicatedDataEntitySuccess{body: @dodai}
      end
    end)

    body = %{
      "question_id" => @dodai["data"]["question_id"],
      "body"        => @dodai["data"]["body"],
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 200
    assert Poison.decode!(res.body) == @gear
  end


  test "create/1 " <> "question not found" do
    mock_fetch_me_plug(%{"_id" => "user_id"})

    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.ResourceNotFound{}

        %Dodai.CreateDedicatedDataEntityRequest{} ->
          %Dodai.CreateDedicatedDataEntitySuccess{body: @dodai}
      end
    end)

    body = %{
      "question_id" => @dodai["data"]["question_id"],
      "body"        => @dodai["data"]["body"],
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
          %Dodai.CreateDedicatedDataEntitySuccess{body: @dodai}
      end
    end)

    body = %{
      "question_id" => @dodai["data"]["question_id"],
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
          %Dodai.CreateDedicatedDataEntitySuccess{body: @dodai}
      end
    end)

    body = %{
      "question_id" => @dodai["data"]["question_id"],
      "body"        => String.duplicate("a", 3001),
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 400
  end

end
