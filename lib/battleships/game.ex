defmodule Battleships.Game do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.{Repo, Ship, ShipCoordGenerator, Shot}

  schema "games" do
    has_many :ships, Ship
    has_many :shots, Shot
    timestamps()
  end

  def create do
    game = %Game{}
    |> Repo.insert!()
    |> populate()
    # |> IO.inspect()

  end

  def populate(game) do
    populate(game, ShipCoordGenerator.generate())
    #TODO: generate a board structure
  end

  def populate(game, {:ok, coords}) do
    for {x, y} <- coords do
      Ship.create(game.id, x, y)
    end
  end

  def populate(_game, {:error, _error}) do
    IO.puts("If you're reading this, you haven't implemented some error handling that you should have.")
  end

  def get_game(game_id) do
    Repo.get(Game, game_id)
    |> Repo.preload([:ships, :shots])
  end

  # def gen_board(game) do

  # end
end
