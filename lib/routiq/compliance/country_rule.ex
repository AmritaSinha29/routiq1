defmodule Routiq.Compliance.CountryRule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "country_rules" do
    field :country_code, :string
    field :effective_date, :date
    field :import_permit_required, :boolean, default: false
    field :labelling_rules, :string
    field :quantity_limits, :string
    field :schedule_class, :string
    field :source_url, :string
    field :substance_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(country_rule, attrs) do
    country_rule
    |> cast(attrs, [:country_code, :schedule_class, :import_permit_required, :quantity_limits, :labelling_rules, :effective_date, :source_url])
    |> validate_required([:country_code, :schedule_class, :import_permit_required, :quantity_limits, :labelling_rules, :effective_date, :source_url])
  end
end
