defmodule Battleships.Repo.Migrations.MakeBoardTable do
  use Ecto.Migration

  def change do
    create table(:boards) do
      add :game_id,   references(:games)
    end
  end
end
