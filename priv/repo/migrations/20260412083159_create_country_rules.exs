defmodule Routiq.Repo.Migrations.CreateCountryRules do
  use Ecto.Migration

  def change do
    create table(:country_rules) do
      add :country_code, :string
      add :schedule_class, :string
      add :import_permit_required, :boolean, default: false, null: false
      add :quantity_limits, :string
      add :labelling_rules, :text
      add :effective_date, :date
      add :source_url, :string
      add :substance_id, references(:substances, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:country_rules, [:substance_id])
  end
end
