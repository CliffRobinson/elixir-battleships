defmodule Battleships.Game do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.{Repo, Board}

  schema "games" do
    has_many :boards, Board

    timestamps()
  end

  def create do
    game = Repo.insert!(%Game{})

    board_a_id = Board.create(game.id)
    board_b_id = Board.create(game.id)

    game.id
  end

  def get_game(game_id) do
    # game =
      Repo.get(Game, game_id)
      |> Repo.preload([boards: [:ships, :shots]])

    # IO.inspect(game)
  end

  def get_game_boards(game) do
    [raw_board_a, raw_board_b] = game.boards

    board_a = Board.gen_array_board(raw_board_a)
    board_b = Board.gen_array_board(raw_board_b)

    {:ok, board_a, board_b}
  end
end
