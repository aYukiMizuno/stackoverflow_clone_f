# Implemented by niulong at 2019-05-21

use Croma

defmodule StackoverflowCloneF.Controller.Comment.UpdateRequestBody do
  alias StackoverflowCloneF.Controller.Comment.Helper.Params

  use Croma.Struct, fields: [
    body: Croma.TypeGen.nilable(Params.Body),
  ]
end

defmodule StackoverflowCloneF.Controller.Comment.Update do
  use StackoverflowCloneF.Controller.Application
  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error.{BadRequestError, ResourceNotFoundError}
  alias StackoverflowCloneF.Controller.Comment.{Helper, UpdateRequestBody}
  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []

  defun update(%Conn{
    assigns: %{me: %{"_id" => user_id}},
    request: %Request{path_matches: %{document_id: document_id, id: comment_id,}, path_info: path_info, body: body}, 
    context: context} = conn) :: Conn.t do

    collection_name = case Enum.fetch!(path_info, 1) do
      "question" -> "Question"
      "answer" -> "Answer"
    end
    
    with_collection(conn, fn question -> 
      commentList = question["data"]["comments"]
      # comment_idで指定するcommentの位置を探す
      indexNub = Enum.find_index(commentList, fn(x) -> x["id"] == comment_id end)
      comment = Enum.fetch!(commentList, indexNub)
      cUser_id = comment["user_id"]

      # 修正権利の認証する
      if user_id == cUser_id do
      ## 修正するコメントのuser_idが登録のuser_idと一致すれば更新処理
        case UpdateRequestBody.new(body) do
          {:error, _}      ->
            ErrorJson.json_by_error(conn, BadRequestError.new())
          {:ok, validated} ->
            
            res_body = Map.from_struct(validated)
            # commentのbodyを入れ替え
            set_data = %{"comments" => List.replace_at(commentList, indexNub, Map.put(comment,"body",res_body.body))}
            req_body = %Dodai.UpdateDedicatedDataEntityRequestBody{data: %{"$set" => set_data}}
            req = Dodai.UpdateDedicatedDataEntityRequest.new(SD.default_group_id(), collection_name, document_id, SD.root_key(), req_body)
            res = Sazabi.G2gClient.send(context, SD.app_id(), req)
            case res do
              %Dodai.UpdateDedicatedDataEntitySuccess{body: doc} -> Conn.json(conn, 200, Helper.to_response_body(doc))
              %Dodai.ResourceNotFound{}                          -> ErrorJson.json_by_error(conn, ResourceNotFoundError.new())
            end
        end
      else
        ## 一致しない場合、下記のようにエラーを返す
        ErrorJson.json_by_error(conn, StackoverflowCloneF.Error.CredentialError.new())
      end
    end)
  end

  def with_collection(%Conn{request: %Request{path_matches: %{document_id: document_id}, path_info: path_info}} = conn, f) do
    collection_name = case Enum.fetch!(path_info, 1) do
      "question" -> "Question"
      "answer" -> "Answer"
    end

    req = Dodai.RetrieveDedicatedDataEntityRequest.new(SD.default_group_id(), collection_name, document_id, SD.root_key())
    res = Sazabi.G2gClient.send(conn.context, SD.app_id(), req)
    case res do
      %Dodai.RetrieveDedicatedDataEntitySuccess{body: body} -> f.(body)
      %Dodai.ResourceNotFound{}                             -> ErrorJson.json_by_error(conn, StackoverflowCloneF.Error.ResourceNotFoundError.new())
    end
  end
end
