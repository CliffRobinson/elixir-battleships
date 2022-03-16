defmodule Battleships.Shot do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.Repo

  schema "shots" do
    field :x, :integer
    field :y, :integer

    belongs_to :game, Battleships.Game
  end

  def shoot(game_id, x, y) do
  %Shot{
    game_id: game_id,
    x: x,
    y: y
  }
  |> Repo.insert!()
  end
end
