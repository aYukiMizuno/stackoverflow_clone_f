use Croma

defmodule StackoverflowCloneF.Repo.Question do
  use AntikytheraAcs.Dodai.Repo.Datastore, [
    datastore_models: [StackoverflowCloneF.Model.Question],
  ]
end
