defmodule Routiq.LogisticsTest do
  use Routiq.DataCase

  alias Routiq.Logistics

  describe "shipments" do
    alias Routiq.Logistics.Shipment

    import Routiq.LogisticsFixtures

    @invalid_attrs %{
      compliance_status: nil,
      destination: nil,
      manifest_data: nil,
      origin: nil,
      status: nil,
      temperature_constraint: nil,
      tracking_number: nil
    }

    test "list_shipments/0 returns all shipments" do
      shipment = shipment_fixture()
      assert Logistics.list_shipments() == [shipment]
    end

    test "get_shipment!/1 returns the shipment with given id" do
      shipment = shipment_fixture()
      assert Logistics.get_shipment!(shipment.id) == shipment
    end

    test "create_shipment/1 with valid data creates a shipment" do
      valid_attrs = %{
        compliance_status: "some compliance_status",
        destination: "some destination",
        manifest_data: %{},
        origin: "some origin",
        status: "some status",
        temperature_constraint: "some temperature_constraint",
        tracking_number: "some tracking_number"
      }

      assert {:ok, %Shipment{} = shipment} = Logistics.create_shipment(valid_attrs)
      assert shipment.compliance_status == "some compliance_status"
      assert shipment.destination == "some destination"
      assert shipment.manifest_data == %{}
      assert shipment.origin == "some origin"
      assert shipment.status == "some status"
      assert shipment.temperature_constraint == "some temperature_constraint"
      assert shipment.tracking_number == "some tracking_number"
    end

    test "create_shipment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logistics.create_shipment(@invalid_attrs)
    end

    test "update_shipment/2 with valid data updates the shipment" do
      shipment = shipment_fixture()

      update_attrs = %{
        compliance_status: "some updated compliance_status",
        destination: "some updated destination",
        manifest_data: %{},
        origin: "some updated origin",
        status: "some updated status",
        temperature_constraint: "some updated temperature_constraint",
        tracking_number: "some updated tracking_number"
      }

      assert {:ok, %Shipment{} = shipment} = Logistics.update_shipment(shipment, update_attrs)
      assert shipment.compliance_status == "some updated compliance_status"
      assert shipment.destination == "some updated destination"
      assert shipment.manifest_data == %{}
      assert shipment.origin == "some updated origin"
      assert shipment.status == "some updated status"
      assert shipment.temperature_constraint == "some updated temperature_constraint"
      assert shipment.tracking_number == "some updated tracking_number"
    end

    test "update_shipment/2 with invalid data returns error changeset" do
      shipment = shipment_fixture()
      assert {:error, %Ecto.Changeset{}} = Logistics.update_shipment(shipment, @invalid_attrs)
      assert shipment == Logistics.get_shipment!(shipment.id)
    end

    test "delete_shipment/1 deletes the shipment" do
      shipment = shipment_fixture()
      assert {:ok, %Shipment{}} = Logistics.delete_shipment(shipment)
      assert_raise Ecto.NoResultsError, fn -> Logistics.get_shipment!(shipment.id) end
    end

    test "change_shipment/1 returns a shipment changeset" do
      shipment = shipment_fixture()
      assert %Ecto.Changeset{} = Logistics.change_shipment(shipment)
    end
  end

  describe "routes" do
    alias Routiq.Logistics.Route

    import Routiq.LogisticsFixtures

    @invalid_attrs %{
      destination: nil,
      is_cold_chain_compliant: nil,
      origin: nil,
      path: nil,
      regulatory_risk_score: nil,
      total_cost: nil,
      total_transit_days: nil
    }

    test "list_routes/0 returns all routes" do
      route = route_fixture()
      assert Logistics.list_routes() == [route]
    end

    test "get_route!/1 returns the route with given id" do
      route = route_fixture()
      assert Logistics.get_route!(route.id) == route
    end

    test "create_route/1 with valid data creates a route" do
      valid_attrs = %{
        destination: "some destination",
        is_cold_chain_compliant: true,
        origin: "some origin",
        path: %{},
        regulatory_risk_score: 42,
        total_cost: 42,
        total_transit_days: 42
      }

      assert {:ok, %Route{} = route} = Logistics.create_route(valid_attrs)
      assert route.destination == "some destination"
      assert route.is_cold_chain_compliant == true
      assert route.origin == "some origin"
      assert route.path == %{}
      assert route.regulatory_risk_score == 42
      assert route.total_cost == 42
      assert route.total_transit_days == 42
    end

    test "create_route/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logistics.create_route(@invalid_attrs)
    end

    test "update_route/2 with valid data updates the route" do
      route = route_fixture()

      update_attrs = %{
        destination: "some updated destination",
        is_cold_chain_compliant: false,
        origin: "some updated origin",
        path: %{},
        regulatory_risk_score: 43,
        total_cost: 43,
        total_transit_days: 43
      }

      assert {:ok, %Route{} = route} = Logistics.update_route(route, update_attrs)
      assert route.destination == "some updated destination"
      assert route.is_cold_chain_compliant == false
      assert route.origin == "some updated origin"
      assert route.path == %{}
      assert route.regulatory_risk_score == 43
      assert route.total_cost == 43
      assert route.total_transit_days == 43
    end

    test "update_route/2 with invalid data returns error changeset" do
      route = route_fixture()
      assert {:error, %Ecto.Changeset{}} = Logistics.update_route(route, @invalid_attrs)
      assert route == Logistics.get_route!(route.id)
    end

    test "delete_route/1 deletes the route" do
      route = route_fixture()
      assert {:ok, %Route{}} = Logistics.delete_route(route)
      assert_raise Ecto.NoResultsError, fn -> Logistics.get_route!(route.id) end
    end

    test "change_route/1 returns a route changeset" do
      route = route_fixture()
      assert %Ecto.Changeset{} = Logistics.change_route(route)
    end
  end
end
