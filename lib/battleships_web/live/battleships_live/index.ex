defmodule BattleshipsWeb.BattleshipsLive.Index do
  #calls the live_view function in battleshipsWeb.ex
  use BattleshipsWeb, :live_view

  alias Battleships.{Game, Shot}

  def mount(%{"id" => id}, session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Battleships.PubSub, "games")
    end

    board = Game.get_game(id) |> Game.gen_board()

    # IO.inspect(board, label: "the board")

    {:ok, assign(socket, [board: board, game_id: id])}
  end

  def handle_info({:game_id, id}, socket) do
    # This is getting the client to reconsult the db (via the server) after it has received a signal from the server.
    #
    new_board = Game.get_game(id) |> Game.gen_board()
    {:noreply, assign(socket, [board: new_board])}
  end

  def handle_event("coord_btn_press", params, socket) do
    [id, x, y] = String.split(params["value"], ":")
    |> Enum.map(&(Integer.parse(&1)))
    |> Enum.map(fn {num, _} -> num end)

    Shot.shoot(id, x, y)

    # No 1: easiest way to refresh:
    # new_board = Game.get_game(id) |> Game.gen_board()
    # {:noreply, assign(socket, [board: new_board])}

    #No 2: refresh/redirect? Can we do that without racing the assign

    #No 3: pubsub
    Phoenix.PubSub.broadcast(Battleships.PubSub, "games", {:game_id, id})

  end

  def button_text(:blank) do
    " "
  end

  def button_text(:ship) do
    "🛳"
  end

  def button_text(:miss) do
    "🌊"
  end

  def button_text(:hit) do
    "🤯"
  end
end
