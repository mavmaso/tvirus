defmodule Tvirus.Repo do
  use Ecto.Repo,
    otp_app: :tvirus,
    adapter: Ecto.Adapters.Postgres
end
