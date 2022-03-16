defmodule Battleships.ShipCoordGenerator do
  @doc """
  Generates a Battleships board with the given width and height.
  You can specify a series of ships in the ship_sizes parameter.  The
  algorithm will place the ships so they are not overlapping and randomly
  either in a vertical or horizontal position.
  On success returns `{:ok, positions}` where positions is a list of
  two-element tuples containing the x and y positions of the ship parts.
  On failure returns `{:error, :not_solvable}`.  You'll need to give it
  a bigger board size for that many ships.
  """
  @spec generate(pos_integer(), pos_integer(), [pos_integer()]) ::
          {:ok, [{non_neg_integer(), non_neg_integer()}]} | {:error, :not_solvable}
  def generate(width \\ 8, height \\ 8, ship_sizes \\ [5, 4, 3, 3, 2]) do
    generate(width, height, ship_sizes, [], 0)
  end

  defp generate(width, height, ship_sizes, existing_positions, retries)

  defp generate(_, _, [], existing_positions, _), do: {:ok, existing_positions}
  defp generate(_, _, _, _, 1000), do: {:error, :not_solvable}

  defp generate(
         width,
         height,
         [ship_size | more_ship_sizes] = ship_sizes,
         existing_positions,
         retries
       ) do
    {dx, dy} = select_random_orientation()
    {start_x, start_y} = select_random_position(ship_size, width, height, dx, dy)

    positions = ship_positions(start_x, start_y, ship_size, dx, dy)

    if any_positions_already_taken?(positions, existing_positions) do
      generate(width, height, ship_sizes, existing_positions, retries + 1)
    else
      generate(width, height, more_ship_sizes, positions ++ existing_positions, 0)
    end
  end

  defp ship_positions(start_x, start_y, ship_size, delta_x, delta_y) do
    for index <- 0..(ship_size - 1) do
      {start_x + index * delta_x, start_y + index * delta_y}
    end
  end

  defp select_random_orientation do
    if coin_toss_heads?(), do: {1, 0}, else: {0, 1}
  end

  defp coin_toss_heads?, do: Enum.random(0..1) == 0

  defp any_positions_already_taken?(positions, existing_positions) do
    Enum.any?(positions, &Enum.member?(existing_positions, &1))
  end

  defp select_random_position(size, width, height, dx, dy) do
    x = random_1d_position(size, width, dx)
    y = random_1d_position(size, height, dy)

    {x, y}
  end

  defp random_1d_position(size, length, delta) do
    Enum.random(0..(length - delta * (size - 1) - 1))
  end
end
