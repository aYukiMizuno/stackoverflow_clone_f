use Croma

defmodule StackoverflowCloneF.Controller.User.LoginParams do
  use Croma.Struct, recursive_new?: true, fields: [
    email:    StackoverflowCloneF.NonEmptyString,
    password: StackoverflowCloneF.NonEmptyString,
  ]
end

defmodule StackoverflowCloneF.Controller.User.Login do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Controller.User.LoginParams

  defun login(%Conn{request: %Request{body: body}, context: context} = conn :: v[Conn.t]) :: Conn.t do
    validate_params(conn, body, LoginParams, fn(conn2, validated_params) ->
      req_body = %Dodai.UserLoginRequestBody{
        email:    validated_params.email,
        password: validated_params.password,
      }
      req = Dodai.UserLoginRequest.new(SD.default_group_id(), SD.app_key(), req_body)
      case Sazabi.G2gClient.send(context, SD.app_id(), req) do
        %Dodai.UserLoginSuccess{body: body} -> Conn.json(conn2, 201, to_response_body(body))
        error                               -> ErrorJson.json_by_error(conn2, error)
      end
    end)
  end

  defunp to_response_body(user :: map) :: map do
    Map.take(user, ["email", "createdAt", "session"])
    |> StackoverflowCloneF.MapUtil.underscore_keys()
    |> Map.put("id", user["_id"])
  end
end
