defmodule Routiq.ComplianceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Routiq.Compliance` context.
  """

  @doc """
  Generate a substance.
  """
  def substance_fixture(attrs \\ %{}) do
    {:ok, substance} =
      attrs
      |> Enum.into(%{
        cas_number: "some cas_number",
        inn_name: "some inn_name",
        name: "some name",
        properties: %{},
        type: "some type"
      })
      |> Routiq.Compliance.create_substance()

    substance
  end

  @doc """
  Generate a country_rule.
  """
  def country_rule_fixture(attrs \\ %{}) do
    {:ok, country_rule} =
      attrs
      |> Enum.into(%{
        country_code: "some country_code",
        effective_date: ~D[2026-04-11],
        import_permit_required: true,
        labelling_rules: "some labelling_rules",
        quantity_limits: "some quantity_limits",
        schedule_class: "some schedule_class",
        source_url: "some source_url"
      })
      |> Routiq.Compliance.create_country_rule()

    country_rule
  end
end
