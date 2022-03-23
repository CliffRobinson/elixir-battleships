defmodule Battleships.Shot do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.Repo

  schema "shots" do
    field :x, :integer
    field :y, :integer

    belongs_to :board, Battleships.Board
  end

  def shoot(game_id, x, y) do
  %Shot{
    board_id: game_id,
    x: x,
    y: y
  }
  |> Repo.insert!()
  end
end
