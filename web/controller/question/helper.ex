use Croma

defmodule StackoverflowCloneF.Controller.Question.Helper do
  use StackoverflowCloneF.Controller.Application

  defmodule Params do
    defmodule Title do
      # タイトルは1文字以上100文字以内。
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,100}\z/u
    end
    defmodule Body do
      # 本文は1文字以上3000文字以内。
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,3000}\z/su
    end
  end

  @collection_name "Question"

  defun collection_name() :: String.t do
    @collection_name
  end

  defun to_response_body(doc :: map) :: map do
    Map.merge(doc["data"], %{
      "id"         => doc["_id"],
      "created_at" => doc["createdAt"],
    })
  end
end
