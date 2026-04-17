defmodule Routiq.Repo.Migrations.CreateShipments do
  use Ecto.Migration

  def change do
    create table(:shipments) do
      add :origin, :string
      add :destination, :string
      add :status, :string
      add :tracking_number, :string
      add :temperature_constraint, :string
      add :manifest_data, :map
      add :compliance_status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
