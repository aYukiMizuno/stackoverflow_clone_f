defmodule StackoverflowCloneF.Controller.Answer.Create do
  use StackoverflowCloneF.Controller.Application

  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Question
  alias StackoverflowCloneF.Controller.Answer.Helper

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []


  defmodule CommentCroma do
    use Croma.Struct, fields: [
      body: Helper.Params.Body,
      question_id: Croma.String,
    ]
  end


  def create(conn) do

    validate(conn, fn (body, question_id) ->
      check_questionid(conn, question_id, fn () ->

        user_id = conn.assigns.me["_id"]

        data = %{
          "user_id"     => user_id,     # login userの`_id`
          "question_id" => question_id, # userが指定した値
          "body"        => body,        # userが指定した値
          "comments"    => [],          # 最初は必ず空配列
        }

        req = Dodai.CreateDedicatedDataEntityRequest.new(
          SD.default_group_id(),
          "Answer",
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
    end)

  end


  def validate(conn, f) do
    case CommentCroma.new(conn.request.body) do
      {:ok, %CommentCroma{body: body, question_id: question_id}} -> f.(body, question_id)
      _ -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
    end
  end

  def check_questionid(conn, id, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{} -> f.()
      %Dodai.ResourceNotFound{}                   -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
    end

  end

end
