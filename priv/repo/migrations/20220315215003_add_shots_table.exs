defmodule Battleships.Repo.Migrations.AddShotsTable do
  use Ecto.Migration

  def change do
    create table(:shots) do
      add :game_id,     references(:games)
      add :x,           :integer
      add :y,           :integer
    end
  end
end
