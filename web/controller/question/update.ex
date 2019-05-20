defmodule StackoverflowCloneF.Controller.Question.Update do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []

  # created by niulong - 2019-05-17
  def update(%Antikythera.Conn{
    assigns: %{me: %{"_id" => user_id}},
    request: %Antikythera.Request{path_matches: %{id: id}}} = conn) do

    # 指定されたidをもつquestionを取得する
    with_question(conn, fn question ->
      # questionのuser_idとログインユーザの_idが一致するか確認
      if user_id == question["data"]["user_id"] do
        # 一致した場合 更新処理

        ## タイトルとボディーな中身を確認する

        # 1. dodaiに対してrequestするrequest bodyを作成する
        res_body = %{
          "title"=> conn.request.body["title"],
          "body"=> conn.request.body["body"],
        }
        req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => res_body}}

        # 2. dodaiに対してrequestするためのstructを作る
        req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key(), req_body)

        ### 3. クライアントにレスポンスを返す(dodaiのresponse bodyがいつもと違うことに注意)
        res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
        case res do
          %Dodai.UpdateDedicatedDataEntitySuccess{body: body} -> Conn.json(conn, 200, body["data"])
          _ -> ErrorJson.json_by_error(conn, StackoverflowCloneF.Error.ResourceNotFoundError.new())
        end

      else
        ## 一致しない場合、下記のようにエラーを返す
        ErrorJson.json_by_error(conn, StackoverflowCloneF.Error.CredentialError.new())
      end

    end)
  end

  def with_question(%Conn{request: %Request{path_matches: %{id: id}}} = conn, f) do
    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), "Question", id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneF.Error.ResourceNotFoundError.new())
    end
  end

end
