use Croma

defmodule StackoverflowCloneF.Comment do
  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,1000}\z/u
  end
  use Croma.Struct, recursive_new?: true, fields: [
    id:         StackoverflowCloneF.DodaiId,
    body:       Body,
    user_id:    StackoverflowCloneF.DodaiId,
    created_at: Croma.String,
  ]
end

defmodule StackoverflowCloneF.CommentList do
  use Croma.SubtypeOfList, elem_module: StackoverflowCloneF.Comment
end
