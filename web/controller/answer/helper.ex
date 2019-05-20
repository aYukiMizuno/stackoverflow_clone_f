use Croma

defmodule StackoverflowCloneF.Controller.Answer.Helper do
  defmodule Params do
    defmodule Body do
      # answerの本文は1文字以上3000文字以内。
      use Croma.SubtypeOfString, pattern: ~r/\A.{1,3000}\z/u
    end
  end

  @collection_name "Answer"

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
