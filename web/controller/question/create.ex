defmodule StackoverflowCloneF.Controller.Question.Create do
  use StackoverflowCloneF.Controller.Application

  alias StackoverflowCloneF.Dodai, as: SD
  alias StackoverflowCloneF.Error
  alias StackoverflowCloneF.Controller.Question

  plug StackoverflowCloneF.Plug.FetchMe, :fetch, []


  defmodule TitleCroma do
    defmodule TitleString do
      use Croma.SubtypeOfString, pattern: ~r/^.{1,100}$/ #
    end
    use Croma.Struct, fields: [
      title: TitleString, # foo fieldとしてThreeNumberStrであることを宣言
      body: Croma.String,  # bar fieldがinteger型として宣言
    ]
  end


  def create(conn) do
    #user_credential = conn.request.headers["authorization"]

    validate(conn, fn (title, body) ->

      user_id = conn.assigns.me["_id"]

      data = %{
        "user_id"           => user_id,# login userの`_id`(この`question`の投稿者の`_id`)
        "title"             => title,                 # userが指定した値
        "body"              => body,                  # userが指定した値
        "like_voter_ids"    => [],                    # 最初は必ず空配列
        "dislike_voter_ids" => [],                    # 最初は必ず空配列
        "comments"          => [],                    # 最初は必ず空配列
      }

      req = Dodai.CreateDedicatedDataEntityRequest.new(
        SD.default_group_id(),
        "Question",
        SD.root_key(),
        %Dodai.CreateDedicatedDataEntityRequestBody{data: data, owner: user_id}
        )

      res = Sazabi.G2gClient.send(
        conn.context,
        SD.app_id(),
        req)

      case res do
        %Dodai.CreateDedicatedDataEntitySuccess{body: data} -> Conn.json(conn, 200, Question.Helper.to_response_body(data))
        %Dodai.BadRequest{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
        %Dodai.AuthenticationError{} -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
        _ -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
      end
    end
    )

  end


  def validate(conn, f) do
    case TitleCroma.new(conn.request.body) do
      {:ok, %TitleCroma{title: title, body: body}} -> f.(title, body)
      _ -> ErrorJson.json_by_error(conn, Error.BadRequestError.new())
    end
  end

end


