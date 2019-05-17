defmodule StackoverflowCloneF.Controller.Question.CreateTest do
  use StackoverflowCloneF.CommonCase
  alias StackoverflowCloneF.TestData.QuestionData

  @api_prefix "/v1/question"

  @header %{
    "authorization" => "user_credential"
  }

  test "create/1 " <> "success" do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, _) ->
      %Dodai.CreateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)
    mock_fetch_me_plug(%{"_id" => "user_id"})

    body = %{
      "title" => "title ",
      "body"  => "message",
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 200
    assert Poison.decode!(res.body) == QuestionData.gear()
  end

  test "create/1 " <> "empty title" do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, _) ->
      %Dodai.CreateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)
    mock_fetch_me_plug(%{"_id" => "user_id"})

    body = %{
      "title" => "",
      "body"  => "message",
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 400
  end


  test "create/1 " <> "too long title" do
    :meck.expect(Sazabi.G2gClient, :send, fn(_, _, _) ->
      %Dodai.CreateDedicatedDataEntitySuccess{body: QuestionData.dodai()}
    end)
    mock_fetch_me_plug(%{"_id" => "user_id"})

    body = %{
      "title" => "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789overflow",
      "body"  => "message",
    }

    res = Req.post_json(@api_prefix, body, @header)

    assert res.status               == 400
  end
end
