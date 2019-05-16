defmodule StackoverflowCloneF.Controller.Question.Update do
  use StackoverflowCloneF.Controller.Application

  def update(%Antikythera.Conn{request: %Antikythera.Request{path_matches: %{id: id}}} = conn) do
    # Implement me
             
    # 1. Requestの構築
    # updateInfo = {"data": "xxx"}
    res_body = %{
        "title" => conn.request.body["title"],
        "body" => conn.request.body["body"],
    }

    IO.puts "--------------------"
    IO.inspect res_body

    group_id = "g_T9Dt6DQk"
    data_collection_name = "Question"
    # id = "5cdcdeec599107049a268014"
    credential = conn.request.headers["authorization"]
    req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: res_body}
    req = Dodai.UpdateDedicatedDataEntityRequest.new(group_id, data_collection_name, id, credential, req_body)
    
    # 2. G2G通信を実行する
    res = Sazabi.G2gClient.send(conn.context, "a_BvqzN73e", req)

    # 3. レスポンスをハンドリングする
    res_body = %{
      data: res.body["data"]
    }

    Conn.json(conn, 200, res_body)


  end
end
