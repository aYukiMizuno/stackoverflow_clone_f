defmodule StackoverflowCloneF.Controller.Answer.Update do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Question
  # alias StackoverflowCloneF.Controller.Book.Helper

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []

  defmodule CommentCroma do
    use Croma.Struct, fields: [
      body: Croma.String
    ]
  end


  def update(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: answer_id}}} = conn) do

    user_id = conn.assigns.me["_id"]

    validate(conn, fn (body) ->
      check_answer(conn, answer_id, user_id, fn () ->

        data = %{
          # "user_id"     => user_id,     # login userの`_id`
          # "question_id" => question_id, # userが指定した値
          "body"        => body,          # userが指定した値
          # "comments"    => [],          # 最初は必ず空配列
        }

        req = Dodai.UpdateDedicatedDataEntityRequest.new(
          SD.default_group_id(),
          "Answer",
          answer_id,
          SD.root_key(),
          %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => data}} # , owner: user_id
          )

        res = Sazabi.G2gClient.send(
          conn.context,
          SD.app_id(),
          req)

        case res do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: data} -> Conn.json(conn, 200, Question.Helper.to_response_body(data))
          # %Dodai.BadRequest{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
          # %Dodai.AuthenticationError{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
          _ -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
        end

      end)
    end)

  end


  def validate(conn, f) do
    case CommentCroma.new(conn.request.body) do
      {:ok, %CommentCroma{body: body}} -> f.(body)
      _ -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
    end
  end


  def check_answer(conn, answer_id, user_id, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Answer", answer_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: %{"data" => %{"user_id" => given_user_id}}} ->
        case given_user_id do
          ^user_id -> f.()
          # %Dodai.ResourceNotFound{} -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
          _ -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
        end
      _ -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
    end

  end

end
