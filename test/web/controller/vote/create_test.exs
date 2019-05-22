defmodule StackoverflowCloneF.Controller.Vote.CreateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData

  @header %{
    "authorization" => "user_credential"
  }

  test "create/1 " <>
    "success upvote" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{}
      end
    end)

    body = %{}

    res = Req.post_json("/v1/question/question_id/vote/like_vote", body, @header)

    assert res.status == 200
    assert Poison.decode!(res.body)["body"] == body["body"]
  end


  test "create/1 " <>
    "fail twice upvote" do

    mock_fetch_me_plug(%{"_id" => "5976b4b037000037006d69c2"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{}
      end
    end)

    body = %{}

    res = Req.post_json("/v1/question/question_id/vote/like_vote", body, @header)

    assert res.status == 400
  end


  test "create/1 " <>
    "success downvote" do

    mock_fetch_me_plug(%{"_id" => "user_id"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{}
      end
    end)

    body = %{}

    res = Req.post_json("/v1/question/question_id/vote/dislike_vote", body, @header)

    assert res.status == 200
    assert Poison.decode!(res.body)["body"] == body["body"]
  end


  test "create/1 " <>
    "fail twice downvote" do

    mock_fetch_me_plug(%{"_id" => "5976b4b037000037006d69c4"})
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, req) ->
      case req do
        %Dodai.RetrieveDedicatedDataEntityRequest{} ->
          %Dodai.RetrieveDedicatedDataEntitySuccess{body: QuestionData.dodai()}
        %Dodai.UpdateDedicatedDataEntityRequest{} ->
          %Dodai.UpdateDedicatedDataEntitySuccess{}
      end
    end)

    body = %{}

    res = Req.post_json("/v1/question/question_id/vote/dislike_vote", body, @header)

    assert res.status == 400
  end
end
