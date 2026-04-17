defmodule Routiq.Repo.Migrations.CreateRoutes do
  use Ecto.Migration

  def change do
    create table(:routes) do
      add :origin, :string
      add :destination, :string
      add :total_transit_days, :integer
      add :total_cost, :integer
      add :is_cold_chain_compliant, :boolean, default: false, null: false
      add :regulatory_risk_score, :integer
      add :path, :map
      add :shipment_id, references(:shipments, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:routes, [:shipment_id])
  end
end
