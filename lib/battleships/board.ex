defmodule Battleships.Board do
  use Ecto.Schema

  alias __MODULE__
  alias Battleships.{Repo, Ship, ShipCoordGenerator, Shot}

  @hit :hit
  @miss :miss
  @blank :blank
  @ship :ship

  schema "boards" do
    has_many :ships, Ship
    has_many :shots, Shot

    belongs_to :game, Battleships.Game
  end

  def create(game_id) do
    #how does this relate to the module name / schema def?
    board = Repo.insert!(%Board{
      game_id: game_id
    })

    populate(board)

    board.id
  end

  def populate(board) do
    populate(board, ShipCoordGenerator.generate())
  end

  def populate(board, {:ok, coords}) do
    for {x, y} <- coords do
      Ship.create(board.id, x, y)
    end
  end

  def populate(_board, {:error, _error}) do
    IO.puts(
      "If you're reading this, you haven't implemented some error handling that you should have."
    )
  end

  def get_board(board_id) do
    board =
      Repo.get(Board, board_id)
      |> Repo.preload([:ships, :shots])

    board
  end

  def gen_array_board(board, width \\ 7, height \\ 7) do
    simple_ships =
      for ship <- board.ships do
        %{x: ship.x, y: ship.y}
      end

    simple_shots =
      for shot <- board.shots do
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
