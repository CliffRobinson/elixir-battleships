defmodule BattleshipsWeb.PageController do
  use BattleshipsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
