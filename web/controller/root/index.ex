use Croma

defmodule StackoverflowCloneF.Controller.Root.Index do
  use StackoverflowCloneF.Controller.Application

  defun index(conn :: Conn.t) :: Conn.t do
    Conn.render(conn, 200, "root/index", [])
  end
end
