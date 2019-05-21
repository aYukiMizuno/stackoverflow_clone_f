use Croma

defmodule StackoverflowCloneF.Controller.Vote.Create do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []


  def create(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: question_id}}} = conn) do

    IO.inspect conn.request.path_info
    collection_name = case conn.request.path_info do
      [_, "answer" | _] -> "Answer"
      [_, "question" | _] -> "Question"
    end
    [positive_list_name, negative_list_name] = case conn.request.path_info do
      [_, _, _, "vote", "like_vote"] -> ["like_voter_ids", "dislike_voter_ids"]
      [_, _, _, "vote", "dislike_vote"] -> ["dislike_voter_ids", "like_voter_ids"]
    end

    check_id(conn, question_id, collection_name, fn () ->

      user_id = conn.assigns.me["_id"]

      req1 = Dodai.UpdateDedicatedDataEntityRequest.new(
        SD.default_group_id(),
        collection_name,
        question_id,
        SD.root_key(),
        %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$addToSet" => %{positive_list_name => user_id}}})

      res1 = Sazabi.G2gClient.send(
        conn.context,
        SD.app_id(),
        req1)


      req2 = Dodai.UpdateDedicatedDataEntityRequest.new(
        SD.default_group_id(),
        collection_name,
        question_id,
        SD.root_key(),
        %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$pull" => %{negative_list_name => user_id}}})

      res2 = Sazabi.G2gClient.send(
        conn.context,
        SD.app_id(),
        req2)

      case res1 do
        %Dodai.UpdateDedicatedDataEntitySuccess{body: data1}  ->
          case res2 do
            %Dodai.UpdateDedicatedDataEntitySuccess{body: data2} ->
              Conn.json(conn, 200, to_response_body(data2))
            _ ->
              Conn.json(conn, 200, to_response_body(data1))
          end
        _ ->
          ErrorJson.json_by_error(conn, Error.BadRequestError.new())
      end

    end)

  end

  def check_id(conn, id, collection_name, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), collection_name, id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)

    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{} -> f.()
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
