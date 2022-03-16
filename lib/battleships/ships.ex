defmodule Battleships.Ship do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Battleships.{Repo}

  schema "ships" do
    field :x,             :integer
    field :y,             :integer

    belongs_to :game,     Battleships.Game
  end

  def create(game_id, x, y) do
    %Ship{
      game_id: game_id,
      x: x,
      y: y
    }
    |> Repo.insert!()
  end
end
