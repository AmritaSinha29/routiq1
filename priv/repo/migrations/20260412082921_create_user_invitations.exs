defmodule Routiq.Repo.Migrations.CreateUserInvitations do
  use Ecto.Migration

  def change do
    create table(:user_invitations) do
      add :email, :string
      add :token, :string
      add :role, :string
      add :organization_id, references(:organizations, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:user_invitations, [:organization_id])
  end
end
