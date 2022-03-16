defmodule Battleships.GameTest do
  use ExUnit.Case

  alias Battleships.Game

  @blank "_"
  @ship "4"

  describe "gen_board" do
    test "make a blank board" do
      game = %{ships: []}

      board = Game.gen_board(game, 1, 1)

      assert board == [
        [@blank, @blank],
        [@blank, @blank]
      ]
    end

    test "make a board with a ship" do
      game = %{ships: [%{x: 0, y: 0}, %{x: 0, y: 1}]}

      board = Game.gen_board(game, 1, 1)

      assert board == [
        [@ship, @blank],
        [@ship, @blank]
      ]
    end
  end
end
