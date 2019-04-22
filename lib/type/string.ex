use Croma

defmodule StackoverflowCloneF.NonEmptyString do
  use Croma.SubtypeOfString, pattern: ~r"\A.+\Z"
end
