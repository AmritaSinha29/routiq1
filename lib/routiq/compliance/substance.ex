defmodule Routiq.Compliance.Substance do
  use Ecto.Schema
  import Ecto.Changeset

  schema "substances" do
    field :cas_number, :string
    field :inn_name, :string
    field :name, :string
    field :properties, :map
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(substance, attrs) do
    substance
    |> cast(attrs, [:name, :cas_number, :inn_name, :type, :properties])
    |> validate_required([:name, :cas_number, :inn_name, :type])
  end
end
