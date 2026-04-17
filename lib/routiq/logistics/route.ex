defmodule Routiq.Logistics.Route do
  use Ecto.Schema
  import Ecto.Changeset

  schema "routes" do
    field :destination, :string
    field :is_cold_chain_compliant, :boolean, default: false
    field :origin, :string
    field :path, :map
    field :regulatory_risk_score, :integer
    field :total_cost, :integer
    field :total_transit_days, :integer
    field :shipment_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(route, attrs) do
    route
    |> cast(attrs, [
      :origin,
      :destination,
      :total_transit_days,
      :total_cost,
      :is_cold_chain_compliant,
      :regulatory_risk_score,
      :path
    ])
    |> validate_required([
      :origin,
      :destination,
      :total_transit_days,
      :total_cost,
      :is_cold_chain_compliant,
      :regulatory_risk_score
    ])
  end
end
