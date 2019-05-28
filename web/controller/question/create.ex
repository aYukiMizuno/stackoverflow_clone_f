defmodule StackoverflowCloneF.Controller.Question.Create do
  use StackoverflowCloneF.Controller.Application

  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Question
  alias StackoverflowCloneF.Controller.Question.Helper

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []


  defmodule QuestionCroma do
    use Croma.Struct, fields: [
      title: Helper.Params.Title,
      body: Helper.Params.Body,
    ]
  end


  def create(conn) do

    validate(conn, fn (title, body) ->

      user_id = conn.assigns.me["_id"]

      data = %{
        "user_id"           => user_id,               # login userの`_id`(この`question`の投稿者の`_id`)
        "title"             => title,                 # userが指定した値
        "body"              => body,                  # userが指定した値
        "like_voter_ids"    => [],                    # 最初は必ず空配列
        "dislike_voter_ids" => [],                    # 最初は必ず空配列
        "comments"          => [],                    # 最初は必ず空配列
      }

      req = Dodai.CreateDedicatedDataEntityRequest.new(
        SD.default_group_id(),
        "Question",
        SD.root_key(),
        %Dodai.CreateDedicatedDataEntityRequestBody{data: data, owner: user_id}
        )

      res = Sazabi.G2gClient.send(
        conn.context,
        SD.app_id(),
        req)

      case res do
        %Dodai.CreateDedicatedDataEntitySuccess{body: data} -> Conn.json(conn, 200, Question.Helper.to_response_body(data))
        %Dodai.BadRequest{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
        %Dodai.AuthenticationError{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
        _ -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
      end

    end)

  end


  def validate(conn, f) do
    case QuestionCroma.new(conn.request.body) do
      {:ok, %QuestionCroma{title: title, body: body}} -> f.(title, body)
      _ -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
    end
  end

end


