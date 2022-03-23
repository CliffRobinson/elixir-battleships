defmodule Battleships.Ship do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__
  alias Battleships.{Repo}

  schema "ships" do
    field :x,             :integer
    field :y,             :integer

    belongs_to :board,     Battleships.Board
  end

  def create(game_id, x, y) do
    %Ship{
      board_id: game_id,
      x: x,
      y: y
    }
    |> Repo.insert!()
  end
end
