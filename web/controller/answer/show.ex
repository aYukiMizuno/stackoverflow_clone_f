use Croma

defmodule StackoverflowCloneF.Controller.Answer.Show do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Controller.Answer.Helper
  alias StackoverflowCloneF.Error.ResourceNotFoundError

  defun show(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: id}}, context: context} = conn) :: Conn.t do

    IO.inspect conn
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Answer", id, SD.root_key())

    res = Sazabi.G2gClient.send(context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> Conn.json(conn, 200, Helper.to_response_body(body))
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
    end
  end
end
