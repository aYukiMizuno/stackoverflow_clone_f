defmodule StackoverflowCloneF.Controller.Comment.CreateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData

  @header %{
    "authorization" => "user_credential"
  }

  @answer_dodai %{
    "_id" => "5cde5fbde515145ec918ade2",
    "createdAt" => "2019-05-17T07:16:13+00:00",
    "data" => %{
      "body" => "body",
      "comments" => [
        %{
          "id"         => "comments_id",
          "user_id"    => "user_id",
          "body"       => "body1",
          "created_at" => "2019-05-17T07:16:13+00:00",
        }
      ],
      "question_id" => "question_id",
      "user_id" => "user_id"
    },
    "owner" => "user_id",
    "sections" => [],
    "updatedAt" => "2019-05-17T07:16:13+00:00",
    "version" => 0
  }



  test "create/1 " <> "success submittion of question comment" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{body: body} ->
          d = put_in(StackoverflowCloneF.TestData.QuestionData.dodai(), ["data", "comments"], [ body.data["$push"]["comments"] ])
          %Dodai.UpdateDedicatedDataEntitySuccess{body: d}
      end
    end)

    body = %{
      "body" => "body",
    }

    res = Req.post_json("/v1/question/question_id/comment", body, @header)

    assert res.status == 200
    assert Poison.decode!(res.body)["body"] == body["body"]
  end


  test "create/1 " <> "invalid body (empty) of question comment" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{body: body} ->
          d = put_in(QuestionData.dodai(), ["data", "comments"], [ body.data["$push"]["comments"] ])
          %Dodai.UpdateDedicatedDataEntitySuccess{body: d}
      end
    end)

    body = %{
      "body" => "",
    }

    res = Req.post_json("/v1/question/question_id/comment", body, @header)

    assert res.status == 400
  end


  test "create/1 " <> "question_id not found" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.ResourceNotFound{}
        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
      end
    end)

    body = %{
      "body" => "body",
    }

    res = Req.post_json("/v1/question/question_id/comment", body, @header)

    assert res.status == 404
  end


  test "create/1 " <> "success submittion of answer comment" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: @answer_dodai}
        %Dodai.UpdateDedicatedDataEntityRequest{body: body} ->
          d = put_in(@answer_dodai, ["data", "comments"], [ body.data["$push"]["comments"] ])
          %Dodai.UpdateDedicatedDataEntitySuccess{body: d}
      end
    end)

    body = %{
      "body" => "body",
    }

    res = Req.post_json("/v1/answer/answer_id/comment", body, @header)

    assert res.status == 200
    assert Poison.decode!(res.body)["body"] == body["body"]
  end


  test "create/1 " <> "invalid body (empty) of answer comment" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{body: body} ->
          d = put_in(StackoverflowCloneF.TestData.QuestionData.dodai(), ["data", "comments"], [ body.data["$push"]["comments"] ])
          %Dodai.UpdateDedicatedDataEntitySuccess{body: d}
      end
    end)

    body = %{
      "body" => "",
    }

    res = Req.post_json("/v1/answer/answer_id/comment", body, @header)

    assert res.status == 400
  end

end
