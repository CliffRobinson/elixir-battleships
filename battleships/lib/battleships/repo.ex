defmodule Battleships.Repo do
  use Ecto.Repo,
    otp_app: :battleships,
    adapter: Ecto.Adapters.Postgres
end
