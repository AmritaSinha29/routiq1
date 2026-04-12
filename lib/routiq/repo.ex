defmodule Routiq.Repo do
  use Ecto.Repo,
    otp_app: :routiq,
    adapter: Ecto.Adapters.Postgres
end
