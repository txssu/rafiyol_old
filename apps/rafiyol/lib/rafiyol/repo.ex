defmodule Rafiyol.Repo do
  use Ecto.Repo,
    otp_app: :rafiyol,
    adapter: Ecto.Adapters.Postgres
end
