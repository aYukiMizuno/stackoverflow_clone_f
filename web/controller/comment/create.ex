defmodule StackoverflowCloneF.Controller.Comment.Create do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Comment.Helper

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []



  defmodule CommentCroma do
    use Croma.Struct, fields: [
      body: Helper.Params.Body
    ]
  end


  def create(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{document_id: document_id}}} = conn) do

    collection_name = case conn.request.path_info do
      [_, "answer" | _] -> "Answer"
      [_, "question" | _] -> "Question"
    end

    validate(conn, fn (body) ->
      user_id = conn.assigns.me["_id"]

      timestamp = Antikythera.Time.now() |> Antikythera.Time.to_iso_timestamp
      comment_id = RandomString.take(20, :alphanumeric)

      comment = %{
        "id"         => comment_id,
        "user_id"    => user_id,     # login userの`_id`
        "body"       => body,        # userが指定した値
        "created_at" => timestamp,
      }

      check_id(conn, document_id, collection_name, fn () ->

        req = Dodai.UpdateDedicatedDataEntityRequest.new(
          SD.default_group_id(),
          collection_name,
          document_id,
          SD.root_key(),
          %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$push" => %{"comments" => comment}}})

        res = Sazabi.G2gClient.send(
          conn.context,
          SD.app_id(),
          req)

        case res do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: data} ->
            Conn.json(conn, 200, data["data"]["comments"] |> Enum.find(fn c -> c["id"] == comment_id end)) ## Helper????
          _ ->
            ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
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

  def check_id(conn, id, collection_name, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), collection_name, id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{} -> f.()
      %Dodai.ResourceNotFound{}                   -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
    end
  end
end
