defmodule Battleships.Game do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.{Repo, Ship, ShipCoordGenerator, Shot}

  @hit "X"
  @miss "."
  @blank "_"
  @ship "4"

  schema "games" do
    has_many :ships, Ship
    has_many :shots, Shot
    timestamps()
  end

  def create do
    game = %Game{}
    |> Repo.insert!()

    populate(game)

    pop_game = get_game(game.id)

    gen_board(pop_game)
    |> IO.inspect()
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
    IO.puts("get gaem called!")
    game = Repo.get(Game, game_id)
    |> Repo.preload([:ships, :shots])

    game
  end

  def gen_board(game) do
    IO.puts("GENBOARD GOT CALLED!")
    # IO.inspect(game.ships)
    simple_ships = for ship <- game.ships do
      %{x: ship.x, y: ship.y}
    end

    IO.inspect(simple_ships)
    #TODO: simple unit tests on 2x2 grid
    #TODO: figure out array overlap/subtraction

    for y_index <- 0..7 do
      for x_index <- 0..7 do
        # for {x_ship, y_ship} <- simple_ships do
          if (Enum.member?(simple_ships, %{x: x_index, y: y_index})) do
            @ship
          else
            @blank
          end
        # end
      end
    end

  end

  # def gen_blank_board() do
  #   for y <- 1..8 do
  #     for x <- 1..8 do
  #       "x:#{x}, y:#{y}"
  #     end
  #   end
  # end

  # def add_ships(board, coords) do
  #   # wip_board = board

  #   List.


  #   for {x, y} <- coords do
  #     row = Enum.at(board, y)
  #     new_row = List.replace_at(row, x, :ship)

  #     ^board = List.replace_at(board, y, new_row)
  #   end

  #   board
  # end
end
