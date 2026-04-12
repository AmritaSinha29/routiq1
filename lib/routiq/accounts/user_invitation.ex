defmodule Routiq.Accounts.UserInvitation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_invitations" do
    field :email, :string
    field :role, :string
    field :token, :string
    field :organization_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_invitation, attrs) do
    user_invitation
    |> cast(attrs, [:email, :token, :role])
    |> validate_required([:email, :token, :role])
  end
end
