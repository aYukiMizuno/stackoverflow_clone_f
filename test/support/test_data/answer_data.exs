defmodule StackoverflowCloneF.TestData.AnswerData do
    @dodai %{
        "_id"       => "answer_id",
        "owner"     => "_root",
        "sections"  => [],
        "version"   => 0,
        "createdAt"=> "2018-02-27T06:34:52+00:00",
        "updatedAt" => "2018-02-27T06:34:52+00:00",
        "data"      => %{
            "question_id"   => "question_id",
            "user_id"       => "user_id",
            "comments"      => [
                %{
                  "id"          => "comment_1",
                  "user_id"     => "user_id",
                  "created_at"  => "2018-02-27T06:35:26+00:00",
                  "body"        => "body1"
                },
                %{
                  "id"          => "comment_2",
                  "user_id"     => "user_id",
                  "created_at"  => "2018-02-27T06:36:26+00:00",
                  "body"        => "body2"
                }
            ],
            "body"         => "body",

        }
        
      }
    @gear Map.merge(@dodai["data"], %{"id" => @dodai["_id"], "created_at" => @dodai["createdAt"]})
  
    def dodai(), do: @dodai
    def gear(),  do: @gear
  end
  