defmodule StackoverflowCloneF.Controller.Question.Show do
  use StackoverflowCloneF.Controller.Application

  alias StackoverflowCloneF.Helper.ErrorJson
  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Question

  def show(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: id}}} = conn) do

    req = Dodai.RetrieveDedicatedDataEntityRequest.new(
      StackoverflowCloneF.Dodai.default_group_id(),
      "Question",
      id,
      StackoverflowCloneF.Dodai.root_key()
      )

    res = Sazabi.G2gClient.send(
      conn.context,
      StackoverflowCloneF.Dodai.app_id(),
      req)

    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: data} -> Conn.json(conn, 200, Question.Helper.to_response_body(data))
      %Dodai.ResourceNotFound{} -> ErrorJson.json_by_error(conn, Error.ResourceNotFoundError.new())
    end

  end
end
