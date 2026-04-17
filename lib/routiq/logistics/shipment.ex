defmodule Routiq.Logistics.Shipment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shipments" do
    field :compliance_status, :string
    field :destination, :string
    field :manifest_data, :map
    field :origin, :string
    field :status, :string
    field :temperature_constraint, :string
    field :tracking_number, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shipment, attrs) do
    shipment
    |> cast(attrs, [:origin, :destination, :status, :tracking_number, :temperature_constraint, :manifest_data, :compliance_status])
    |> validate_required([:origin, :destination, :status, :tracking_number, :temperature_constraint, :compliance_status])
  end
end
