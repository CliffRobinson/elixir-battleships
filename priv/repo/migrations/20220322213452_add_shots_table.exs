defmodule Battleships.Repo.Migrations.AddShotsTable do
  use Ecto.Migration

  def change do
    create table(:shots) do
      add :board_id,     references(:boards)
      add :x,           :integer
      add :y,           :integer
    end
  end
end
