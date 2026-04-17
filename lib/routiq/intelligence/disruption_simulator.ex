defmodule Routiq.Intelligence.DisruptionSimulator do
  @moduledoc """
  Simulates a supply chain disruption (e.g., Suez Canal Congestion) 
  and broadcasts the event via Phoenix.PubSub.
  """

  alias Phoenix.PubSub

  @pubsub_topic "shipment_disruptions"

  @doc """
  Triggers a simulated disruption for a specific shipment.
  """
  def trigger_disruption(shipment_id, scenario_type \\ :suez_congestion) do
    disruption = case scenario_type do
      :suez_congestion ->
        %{
          shipment_id: shipment_id,
          type: "delay",
          source: "Suez Canal Authority / AIS Feed",
          impact: "Vessel diverted. Expected delay: 9 days.",
          severity: "critical"
        }
      _ ->
        %{
          shipment_id: shipment_id,
          type: "unknown",
          impact: "Minor delay.",
          severity: "low"
        }
    end

    # Broadcast to any connected LiveViews listening to this shipment's topic
    PubSub.broadcast(
      Routiq.PubSub,
      "#{@pubsub_topic}:#{shipment_id}",
      {:disruption_event, disruption}
    )

    {:ok, disruption}
  end

  @doc """
  Subscribes the current process (usually a LiveView) to disruption events for a shipment.
  """
  def subscribe(shipment_id) do
    PubSub.subscribe(Routiq.PubSub, "#{@pubsub_topic}:#{shipment_id}")
  end
end
