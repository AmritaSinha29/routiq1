defmodule Routiq.Intelligence.RouteScorer do
  @moduledoc """
  Scores routes based on Time, Cost, Cold Chain Viability, and Regulatory Risk.
  """

  @doc """
  Calculates a score for a given route. Lower score is better.
  Weights can be adjusted based on shipment priorities.
  """
  def score_route(route, _shipment_constraints) do
    # Base score calculated from days and cost
    base_score = (route.total_transit_days * 10) + (route.total_cost / 100)

    # Penalties
    cold_chain_penalty = if route.is_cold_chain_compliant, do: 0, else: 5000
    regulatory_penalty = route.regulatory_risk_score * 100

    total_score = base_score + cold_chain_penalty + regulatory_penalty

    # Return route with calculated score
    Map.put(route, :calculated_score, total_score)
  end

  @doc """
  Given a disruption event and a list of alternative routes,
  returns the routes sorted by best score.
  """
  def evaluate_alternatives(alternatives, shipment_constraints) do
    alternatives
    |> Enum.map(&score_route(&1, shipment_constraints))
    |> Enum.sort_by(&(&1.calculated_score))
  end
end
