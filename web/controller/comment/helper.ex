use Croma

defmodule StackoverflowCloneF.Controller.Comment.Helper do
  use StackoverflowCloneF.Controller.Application

  defmodule Params do
    defmodule Body do
      # コメントは1文字以上3000文字以内。
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,3000}\z/u
    end
  end

  defun to_response_body(doc :: map) :: map do
    Map.merge(doc["data"], %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
    })
  end
end
