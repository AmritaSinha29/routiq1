defmodule Routiq.Repo.Migrations.CreateSubstances do
  use Ecto.Migration

  def change do
    create table(:substances) do
      add :name, :string
      add :cas_number, :string
      add :inn_name, :string
      add :type, :string
      add :properties, :map

      timestamps(type: :utc_datetime)
    end
  end
end
