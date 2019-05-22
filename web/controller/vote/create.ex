use Croma

defmodule StackoverflowCloneF.Controller.Vote.Create do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []


  def create(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: question_id}}} = conn) do

    collection_name = case conn.request.path_info do
      [_, "answer" | _] -> "Answer"
      [_, "question" | _] -> "Question"
    end
    [positive_list_name, negative_list_name] = case conn.request.path_info do
      [_, _, _, "vote", "like_vote"] -> ["like_voter_ids", "dislike_voter_ids"]
      [_, _, _, "vote", "dislike_vote"] -> ["dislike_voter_ids", "like_voter_ids"]
    end

    check_id(conn, question_id, collection_name, fn (%{"data" => data} = _body) ->

      user_id = conn.assigns.me["_id"]

      if (data[positive_list_name] |> Enum.any?(&(&1 == user_id))) do
        ErrorJson.json_by_error(conn, Error.BadRequestError.new())

      else

        req1 = Dodai.UpdateDedicatedDataEntityRequest.new( # TODO: 重複してもエラーにならない
          SD.default_group_id(),
          collection_name,
          question_id,
          SD.root_key(),
          %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{
            "$addToSet" => %{positive_list_name => user_id},
            "$pull" => %{negative_list_name => user_id},
          }}
        )

        res1 = Sazabi.G2gClient.send(
          conn.context,
          SD.app_id(),
          req1
        )

        case res1 do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: data1}  ->
            Conn.json(conn, 200, to_response_body(data1))
          _ ->
            ErrorJson.json_by_error(conn, Error.BadRequestError.new())
        end

      end

    end)

  end


  defunp check_id(conn :: v[Conn.t], id :: String, collection_name :: String, f) :: Conn.t do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), collection_name, id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{} -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
    end
  end


  defunp to_response_body(doc :: map) :: map do
    %{
      "like_voter_ids"    => doc["data"]["like_voter_ids"],
      "dislike_voter_ids" => doc["data"]["dislike_voter_ids"],
    }
  end
end
