defmodule Routiq.LogisticsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Routiq.Logistics` context.
  """

  @doc """
  Generate a shipment.
  """
  def shipment_fixture(attrs \\ %{}) do
    {:ok, shipment} =
      attrs
      |> Enum.into(%{
        compliance_status: "some compliance_status",
        destination: "some destination",
        manifest_data: %{},
        origin: "some origin",
        status: "some status",
        temperature_constraint: "some temperature_constraint",
        tracking_number: "some tracking_number"
      })
      |> Routiq.Logistics.create_shipment()

    shipment
  end

  @doc """
  Generate a route.
  """
  def route_fixture(attrs \\ %{}) do
    {:ok, route} =
      attrs
      |> Enum.into(%{
        destination: "some destination",
        is_cold_chain_compliant: true,
        origin: "some origin",
        path: %{},
        regulatory_risk_score: 42,
        total_cost: 42,
        total_transit_days: 42
      })
      |> Routiq.Logistics.create_route()

    route
  end
end
