defmodule BattleshipsWeb.PageController do
  use BattleshipsWeb, :controller

  alias Battleships.Game

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_game(conn, _params) do
    game_id = Game.create()

    redirect(conn, to: "/game/#{game_id}")
  end

  def get_game(conn, %{"id" => id}) do
    board = Game.get_game(id)
    |> Game.gen_array_board()

    conn
    |> assign(:board, board)
    |> render("game.html")
  end
end
