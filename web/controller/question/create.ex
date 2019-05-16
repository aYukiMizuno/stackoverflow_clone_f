defmodule StackoverflowCloneF.Controller.Question.Create do
  use StackoverflowCloneF.Controller.Application

  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Question

  def create(conn) do

    credential = conn.request.headers["authorization"]

    req = Dodai.CreateDedicatedDataEntityRequest.new(
      StackoverflowCloneF.Dodai.default_group_id(),
      "Question",
      credential,
      %Dodai.CreateDedicatedDataEntityRequestBody{data: %{
        "title" => conn.request.body["title"],
        "body" => conn.request.body["body"]
        }}
      )

    res = Sazabi.G2gClient.send(
      conn.context,
      StackoverflowCloneF.Dodai.app_id(),
      req)

    case res do
      %Dodai.CreateDedicatedDataEntitySuccess{body: data} -> Conn.json(conn, 200, Question.Helper.to_response_body(data))
      %Dodai.BadRequest{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
      %Dodai.AuthenticationError{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
    end

  end
end


