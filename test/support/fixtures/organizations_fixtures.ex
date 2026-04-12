defmodule Routiq.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Routiq.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{
        gstin: "some gstin",
        name: "some name",
        type: "some type"
      })
      |> Routiq.Organizations.create_organization()

    organization
  end
end
