use Croma

defmodule StackoverflowCloneF.Controller.Application do
  defmacro __using__(_) do
    quote do
      use Antikythera.Controller

      alias Antikythera.{Conn, Request}
      alias StackoverflowCloneF.DodaiId
      alias StackoverflowCloneF.Helper.ErrorJson

      defp validate_imp(validator, v) when is_function(validator) do
        validator.(v)
      end
      defp validate_imp(validator, v) when is_atom(validator) do
        validator.new(v)
      end

      defun validate_params(conn :: v[Conn.t], v :: Dict.t, validator :: module | fun, f :: ((Conn.t, any) -> any)) :: any do
        case validate_imp(validator, v) do
          {:ok, validated} -> f.(conn, validated)
          {:error, _}      -> ErrorJson.json_by_error(conn, StackoverflowCloneF.Error.BadRequestError.new())
        end
      end
    end
  end
end
