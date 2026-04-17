defmodule Routiq.Compliance do
  @moduledoc """
  The Compliance context.
  """

  import Ecto.Query, warn: false
  alias Routiq.Repo

  alias Routiq.Compliance.Substance

  @doc """
  Returns the list of substances.

  ## Examples

      iex> list_substances()
      [%Substance{}, ...]

  """
  def list_substances do
    Repo.all(Substance)
  end

  @doc """
  Gets a single substance.

  Raises `Ecto.NoResultsError` if the Substance does not exist.

  ## Examples

      iex> get_substance!(123)
      %Substance{}

      iex> get_substance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_substance!(id), do: Repo.get!(Substance, id)

  @doc """
  Creates a substance.

  ## Examples

      iex> create_substance(%{field: value})
      {:ok, %Substance{}}

      iex> create_substance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_substance(attrs \\ %{}) do
    %Substance{}
    |> Substance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a substance.

  ## Examples

      iex> update_substance(substance, %{field: new_value})
      {:ok, %Substance{}}

      iex> update_substance(substance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_substance(%Substance{} = substance, attrs) do
    substance
    |> Substance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a substance.

  ## Examples

      iex> delete_substance(substance)
      {:ok, %Substance{}}

      iex> delete_substance(substance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_substance(%Substance{} = substance) do
    Repo.delete(substance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking substance changes.

  ## Examples

      iex> change_substance(substance)
      %Ecto.Changeset{data: %Substance{}}

  """
  def change_substance(%Substance{} = substance, attrs \\ %{}) do
    Substance.changeset(substance, attrs)
  end

  alias Routiq.Compliance.CountryRule

  @doc """
  Returns the list of country_rules.

  ## Examples

      iex> list_country_rules()
      [%CountryRule{}, ...]

  """
  def list_country_rules do
    Repo.all(CountryRule)
  end

  @doc """
  Gets a single country_rule.

  Raises `Ecto.NoResultsError` if the Country rule does not exist.

  ## Examples

      iex> get_country_rule!(123)
      %CountryRule{}

      iex> get_country_rule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_country_rule!(id), do: Repo.get!(CountryRule, id)

  @doc """
  Creates a country_rule.

  ## Examples

      iex> create_country_rule(%{field: value})
      {:ok, %CountryRule{}}

      iex> create_country_rule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country_rule(attrs \\ %{}) do
    %CountryRule{}
    |> CountryRule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country_rule.

  ## Examples

      iex> update_country_rule(country_rule, %{field: new_value})
      {:ok, %CountryRule{}}

      iex> update_country_rule(country_rule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country_rule(%CountryRule{} = country_rule, attrs) do
    country_rule
    |> CountryRule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a country_rule.

  ## Examples

      iex> delete_country_rule(country_rule)
      {:ok, %CountryRule{}}

      iex> delete_country_rule(country_rule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country_rule(%CountryRule{} = country_rule) do
    Repo.delete(country_rule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country_rule changes.

  ## Examples

      iex> change_country_rule(country_rule)
      %Ecto.Changeset{data: %CountryRule{}}

  """
  def change_country_rule(%CountryRule{} = country_rule, attrs \\ %{}) do
    CountryRule.changeset(country_rule, attrs)
  end
end
