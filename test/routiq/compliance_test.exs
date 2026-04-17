defmodule Routiq.ComplianceTest do
  use Routiq.DataCase

  alias Routiq.Compliance

  describe "substances" do
    alias Routiq.Compliance.Substance

    import Routiq.ComplianceFixtures

    @invalid_attrs %{cas_number: nil, inn_name: nil, name: nil, properties: nil, type: nil}

    test "list_substances/0 returns all substances" do
      substance = substance_fixture()
      assert Compliance.list_substances() == [substance]
    end

    test "get_substance!/1 returns the substance with given id" do
      substance = substance_fixture()
      assert Compliance.get_substance!(substance.id) == substance
    end

    test "create_substance/1 with valid data creates a substance" do
      valid_attrs = %{
        cas_number: "some cas_number",
        inn_name: "some inn_name",
        name: "some name",
        properties: %{},
        type: "some type"
      }

      assert {:ok, %Substance{} = substance} = Compliance.create_substance(valid_attrs)
      assert substance.cas_number == "some cas_number"
      assert substance.inn_name == "some inn_name"
      assert substance.name == "some name"
      assert substance.properties == %{}
      assert substance.type == "some type"
    end

    test "create_substance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Compliance.create_substance(@invalid_attrs)
    end

    test "update_substance/2 with valid data updates the substance" do
      substance = substance_fixture()

      update_attrs = %{
        cas_number: "some updated cas_number",
        inn_name: "some updated inn_name",
        name: "some updated name",
        properties: %{},
        type: "some updated type"
      }

      assert {:ok, %Substance{} = substance} =
               Compliance.update_substance(substance, update_attrs)

      assert substance.cas_number == "some updated cas_number"
      assert substance.inn_name == "some updated inn_name"
      assert substance.name == "some updated name"
      assert substance.properties == %{}
      assert substance.type == "some updated type"
    end

    test "update_substance/2 with invalid data returns error changeset" do
      substance = substance_fixture()
      assert {:error, %Ecto.Changeset{}} = Compliance.update_substance(substance, @invalid_attrs)
      assert substance == Compliance.get_substance!(substance.id)
    end

    test "delete_substance/1 deletes the substance" do
      substance = substance_fixture()
      assert {:ok, %Substance{}} = Compliance.delete_substance(substance)
      assert_raise Ecto.NoResultsError, fn -> Compliance.get_substance!(substance.id) end
    end

    test "change_substance/1 returns a substance changeset" do
      substance = substance_fixture()
      assert %Ecto.Changeset{} = Compliance.change_substance(substance)
    end
  end

  describe "country_rules" do
    alias Routiq.Compliance.CountryRule

    import Routiq.ComplianceFixtures

    @invalid_attrs %{
      country_code: nil,
      effective_date: nil,
      import_permit_required: nil,
      labelling_rules: nil,
      quantity_limits: nil,
      schedule_class: nil,
      source_url: nil
    }

    test "list_country_rules/0 returns all country_rules" do
      country_rule = country_rule_fixture()
      assert Compliance.list_country_rules() == [country_rule]
    end

    test "get_country_rule!/1 returns the country_rule with given id" do
      country_rule = country_rule_fixture()
      assert Compliance.get_country_rule!(country_rule.id) == country_rule
    end

    test "create_country_rule/1 with valid data creates a country_rule" do
      valid_attrs = %{
        country_code: "some country_code",
        effective_date: ~D[2026-04-11],
        import_permit_required: true,
        labelling_rules: "some labelling_rules",
        quantity_limits: "some quantity_limits",
        schedule_class: "some schedule_class",
        source_url: "some source_url"
      }

      assert {:ok, %CountryRule{} = country_rule} = Compliance.create_country_rule(valid_attrs)
      assert country_rule.country_code == "some country_code"
      assert country_rule.effective_date == ~D[2026-04-11]
      assert country_rule.import_permit_required == true
      assert country_rule.labelling_rules == "some labelling_rules"
      assert country_rule.quantity_limits == "some quantity_limits"
      assert country_rule.schedule_class == "some schedule_class"
      assert country_rule.source_url == "some source_url"
    end

    test "create_country_rule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Compliance.create_country_rule(@invalid_attrs)
    end

    test "update_country_rule/2 with valid data updates the country_rule" do
      country_rule = country_rule_fixture()

      update_attrs = %{
        country_code: "some updated country_code",
        effective_date: ~D[2026-04-12],
        import_permit_required: false,
        labelling_rules: "some updated labelling_rules",
        quantity_limits: "some updated quantity_limits",
        schedule_class: "some updated schedule_class",
        source_url: "some updated source_url"
      }

      assert {:ok, %CountryRule{} = country_rule} =
               Compliance.update_country_rule(country_rule, update_attrs)

      assert country_rule.country_code == "some updated country_code"
      assert country_rule.effective_date == ~D[2026-04-12]
      assert country_rule.import_permit_required == false
      assert country_rule.labelling_rules == "some updated labelling_rules"
      assert country_rule.quantity_limits == "some updated quantity_limits"
      assert country_rule.schedule_class == "some updated schedule_class"
      assert country_rule.source_url == "some updated source_url"
    end

    test "update_country_rule/2 with invalid data returns error changeset" do
      country_rule = country_rule_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Compliance.update_country_rule(country_rule, @invalid_attrs)

      assert country_rule == Compliance.get_country_rule!(country_rule.id)
    end

    test "delete_country_rule/1 deletes the country_rule" do
      country_rule = country_rule_fixture()
      assert {:ok, %CountryRule{}} = Compliance.delete_country_rule(country_rule)
      assert_raise Ecto.NoResultsError, fn -> Compliance.get_country_rule!(country_rule.id) end
    end

    test "change_country_rule/1 returns a country_rule changeset" do
      country_rule = country_rule_fixture()
      assert %Ecto.Changeset{} = Compliance.change_country_rule(country_rule)
    end
  end
end
