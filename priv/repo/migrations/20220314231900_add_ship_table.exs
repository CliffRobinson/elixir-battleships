defmodule Battleships.Repo.Migrations.AddShipTable do
  use Ecto.Migration

  def change do
    create table(:ships) do
      add :game_id,     references(:games)
      add :x,           :integer
      add :y,           :integer
    end
  end
end
