defmodule BattleshipsWeb.BattleshipsLive.Index do
  #calls the live_view function in battleshipsWeb.ex
  use BattleshipsWeb, :live_view

  alias Battleships.{Game, Shot}

  def mount(%{"id" => id}, session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Battleships.PubSub, "games")
    end

    game = Game.get_game(id)

    [id_a, id_b] = Enum.map(game.boards, &(&1.id))

    {:ok, board_a, board_b} = Game.get_game_boards(game)

    {:ok, assign(socket, [
      board_a: board_a,
      id_a: id_a,
      board_b: board_b,
      id_b: id_b,
      game_id: id])}
  end

  def handle_info({:game_id, id}, socket) do
    # This is getting the client to reconsult the db (via the server) after it has received a signal from the server.
    #

    #Dedup this to gen_assigns?
    game = Game.get_game(id)

    [id_a, id_b] = Enum.map(game.boards, &(&1.id))

    {:ok, board_a, board_b} = Game.get_game_boards(game)

    {:noreply, assign(socket, [
      board_a: board_a,
      id_a: id_a,
      board_b: board_b,
      id_b: id_b,
      game_id: id])}
  end

  def handle_event("coord_btn_press", params, socket) do
    [game_id, board_id, x, y] = String.split(params["value"], ":")
    |> Enum.map(&(Integer.parse(&1)))
    |> Enum.map(fn {num, _} -> num end)

    Shot.shoot(board_id, x, y)

    # No 1: easiest way to refresh:
    # new_board = Game.get_game(id) |> Game.gen_array_board()
    # {:noreply, assign(socket, [board: new_board])}

    #No 2: refresh/redirect? Can we do that without racing the assign

    #No 3: pubsub
    Phoenix.PubSub.broadcast(Battleships.PubSub, "games", {:game_id, game_id})

    {:noreply, socket}
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
