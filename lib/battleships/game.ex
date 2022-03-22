defmodule Battleships.Game do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.{Repo, Ship, ShipCoordGenerator, Shot}

  @hit :hit
  @miss :miss
  @blank :blank
  @ship :ship

  schema "games" do
    has_many :ships, Ship
    has_many :shots, Shot
    timestamps()
  end

  def create do
    game = Repo.insert!(%Game{})

    populate(game)

    game.id
  end

  def populate(game) do
    populate(game, ShipCoordGenerator.generate())
  end

  def populate(game, {:ok, coords}) do
    for {x, y} <- coords do
      Ship.create(game.id, x, y)
    end
  end

  def populate(_game, {:error, _error}) do
    IO.puts(
      "If you're reading this, you haven't implemented some error handling that you should have."
    )
  end

  def get_game(game_id) do
    IO.puts("get gaem called!")

    game =
      Repo.get(Game, game_id)
      |> Repo.preload([:ships, :shots])

    game
  end

  def gen_board(game, width \\ 7, height \\ 7) do
    simple_ships =
      for ship <- game.ships do
        %{x: ship.x, y: ship.y}
      end

    simple_shots =
      for shot <- game.shots do
        %{x: shot.x, y: shot.y}
      end

    unhit_ships = simple_ships -- simple_shots
    misses = simple_shots -- simple_ships
    hits = simple_ships -- unhit_ships

    # IO.inspect(simple_ships)

    #this double comprehension is the same as a comprehension within a comprehension
    #lol no it isn't! Single comp produces a 64 value single array, separate lines produces 8*8 double array0
    for y_index <- 0..height do
      for x_index <- 0..width do
        cond do
          Enum.member?(unhit_ships, %{x: x_index, y: y_index}) -> @ship
          Enum.member?(hits, %{x: x_index, y: y_index}) -> @hit
          Enum.member?(misses, %{x: x_index, y: y_index}) -> @miss
          true -> @blank
        end
      end
    end
  end
end
