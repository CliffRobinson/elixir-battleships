defmodule Battleships.Repo.Migrations.AddGamesTable do
  use Ecto.Migration

  def change do
    create table(:games) do

      timestamps()
    end
  end
end
