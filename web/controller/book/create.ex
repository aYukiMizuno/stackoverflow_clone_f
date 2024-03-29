use Croma

defmodule StackoverflowCloneF.Controller.Book.CreateRequestBody do
  alias StackoverflowCloneF.Controller.Book.Helper.Params

  use Croma.Struct, fields: [
    title:  Params.Title,
    author: Params.Author,
  ]
end

defmodule StackoverflowCloneF.Controller.Book.Create do
  use StackoverflowCloneF.Controller.Application
  alias Sazabi.G2gClient
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error.BadRequestError
  alias StackoverflowCloneF.Controller.Book.{Helper, CreateRequestBody}

  defun create(%Conn{request: %Request{body: body}, context: context} = conn) :: Conn.t do
    case CreateRequestBody.new(body) do
      {:error, _}      ->
        ErrorJson.json_by_error(conn, BadRequestError.new())
      {:ok, validated} ->
        req_body = %Dodai.CreateDedicatedDataEntityRequestBody{data: Map.from_struct(validated)}
        req = Dodai.CreateDedicatedDataEntityRequest.new(SD.default_group_id(), Helper.collection_name(), SD.root_key(), req_body)
        %Dodai.CreateDedicatedDataEntitySuccess{body: res_body} = G2gClient.send(context, SD.app_id(), req)
        Conn.json(conn, 201, Helper.to_response_body(res_body))
    end
  end
end
