use Croma

defmodule StackoverflowCloneF.Model.Answer do
  @moduledoc """
  Answer of StackoverflowCloneF app.
  """

  defmodule Body do
    use Croma.SubtypeOfString, pattern: ~r/\A[\s\S]{1,3000}\z/u
  end

  use AntikytheraAcs.Dodai.Model.Datastore, data_fields: [
    body:        Body,
    user_id:     StackoverflowCloneF.DodaiId,
    question_id: StackoverflowCloneF.DodaiId,
    comments:    StackoverflowCloneF.CommentList,
  ]
end
