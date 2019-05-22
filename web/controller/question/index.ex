defmodule StackoverflowCloneF.Controller.Question.Index do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Controller.Question.Helper

  def index(conn) do
    query = case conn.request.query_params do
      %{"user_id" => user_id} ->
        %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
          query: %{"owner" => user_id},
          sort:  %{"_id" => 1},
        }
      _ ->
        %Dodai.RetrieveDedicatedDataEntityListRequestQuery{
          query: %{},
          sort:  %{"_id" => 1},
        }
    end
    req = Dodai.RetrieveDedicatedDataEntityListRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), query)
    %Dodai.RetrieveDedicatedDataEntityListSuccess{body: docs} = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    Conn.json(conn, 200, Enum.map(docs, &Helper.to_response_body(&1)))
  end
end
