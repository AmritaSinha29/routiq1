defmodule RoutiqWeb.ShipmentLive.Show do
  use RoutiqWeb, :live_view

  alias Routiq.Logistics
  alias Routiq.Intelligence.DisruptionSimulator
  alias Routiq.Intelligence.RouteScorer

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket), do: DisruptionSimulator.subscribe(id)

    shipment = Logistics.get_shipment!(id)

    routes = [
      %{
        id: 1,
        origin: shipment.origin,
        destination: shipment.destination,
        total_transit_days: 22,
        total_cost: 2400,
        is_cold_chain_compliant: true,
        regulatory_risk_score: 0,
        path: "Nhava Sheva -> Suez Canal -> Rotterdam"
      },
      %{
        id: 2,
        origin: shipment.origin,
        destination: shipment.destination,
        total_transit_days: 31,
        total_cost: 3200,
        is_cold_chain_compliant: true,
        regulatory_risk_score: 0,
        path: "Nhava Sheva -> Cape of Good Hope -> Rotterdam"
      },
      %{
        id: 3,
        origin: shipment.origin,
        destination: shipment.destination,
        total_transit_days: 28,
        total_cost: 2600,
        is_cold_chain_compliant: false,
        regulatory_risk_score: 8,
        path: "Nhava Sheva -> Colombo (Non-GDP) -> Rotterdam"
      }
    ]

    scored_routes = RouteScorer.evaluate_alternatives(routes, %{})

    socket =
      socket
      |> assign(:page_title, "Shipment Details")
      |> assign(:active_tab, :shipments)
      |> assign(:shipment, shipment)
      |> assign(:disruption, nil)
      |> assign(:scored_routes, scored_routes)
      |> assign(:active_route, Enum.at(scored_routes, 0))

    {:ok, socket}
  end

  @impl true
  def handle_event("trigger_disruption", _, socket) do
    DisruptionSimulator.trigger_disruption(socket.assigns.shipment.id, :suez_congestion)
    {:noreply, socket}
  end

  @impl true
  def handle_event("select_route", %{"id" => id}, socket) do
    route_id = String.to_integer(id)
    selected = Enum.find(socket.assigns.scored_routes, &(&1.id == route_id))

    {:noreply,
     socket
     |> assign(:active_route, selected)
     # clear disruption modal after selecting new route
     |> assign(:disruption, nil)
     |> put_flash(:success, "Route successfully updated to #{selected.path}")}
  end

  @impl true
  def handle_info({:disruption_event, disruption}, socket) do
    {:noreply, assign(socket, :disruption, disruption)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6 relative">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 animate-fade-in-up">
        <div>
          <div class="flex items-center gap-3">
            <.link navigate={~p"/shipments"} class="text-gray-400 hover:text-white transition-colors">
              <span class="hero-arrow-left w-5 h-5"></span>
            </.link>
            <h1 class="text-2xl font-bold text-white font-display tracking-tight">
              {@shipment.tracking_number}<span class="text-accent">.</span>
            </h1>
            <span class={"badge #{status_badge(@shipment.status)}"}>
              {@shipment.status}
            </span>
          </div>
          <p class="text-gray-400 text-sm mt-1 ml-8">
            {@shipment.origin} → {@shipment.destination}
          </p>
        </div>
        <div class="flex gap-3">
          <button
            phx-click="trigger_disruption"
            class="btn-ghost flex items-center gap-2 border-red-500/30 text-red-400 hover:bg-red-500/10"
          >
            <span class="hero-exclamation-triangle w-4 h-4"></span> Simulate Disruption
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Main details -->
        <div class="lg:col-span-2 space-y-6">
          <div class="glass-card p-6 animate-fade-in-up">
            <h2 class="text-lg font-semibold text-white font-display flex items-center gap-2 mb-4">
              <span class="hero-document-text w-5 h-5 text-accent"></span> Manifest Intelligence
            </h2>
            <div class="grid grid-cols-2 gap-6 mb-6">
              <div>
                <p class="text-sm text-gray-500 mb-1">Product</p>
                <p class="text-white font-medium">{@shipment.manifest_data["product"]}</p>
              </div>
              <div>
                <p class="text-sm text-gray-500 mb-1">Quantity</p>
                <p class="text-white font-medium">{@shipment.manifest_data["quantity"]}</p>
              </div>
            </div>
            <div>
              <p class="text-sm text-gray-500 mb-2">Extracted Active Ingredients</p>
              <div class="flex flex-wrap gap-2">
                <%= for api <- @shipment.manifest_data["apis"] do %>
                  <span class="badge badge-info">{api}</span>
                <% end %>
              </div>
            </div>
          </div>

          <div class="glass-card p-6 animate-fade-in-up">
            <h2 class="text-lg font-semibold text-white font-display flex items-center gap-2 mb-4">
              <span class="hero-map w-5 h-5 text-brand"></span> Active Route: {@active_route.path}
            </h2>
            <div class="flex justify-between items-center bg-white/[0.02] p-4 rounded-xl border border-white/[0.05]">
              <div class="text-center">
                <p class="text-xs text-gray-500 uppercase tracking-wider mb-1">Transit Time</p>
                <p class="text-xl font-bold text-white">{@active_route.total_transit_days} Days</p>
              </div>
              <div class="text-center">
                <p class="text-xs text-gray-500 uppercase tracking-wider mb-1">Cost</p>
                <p class="text-xl font-bold text-white">${@active_route.total_cost}</p>
              </div>
              <div class="text-center">
                <p class="text-xs text-gray-500 uppercase tracking-wider mb-1">Cold Chain</p>
                <%= if @active_route.is_cold_chain_compliant do %>
                  <p class="text-xl font-bold text-emerald-400">Maintained</p>
                <% else %>
                  <p class="text-xl font-bold text-red-400">Compromised</p>
                <% end %>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Sidebar -->
        <div class="space-y-6">
          <div class="glass-card p-6 animate-fade-in-up">
            <h2 class="text-lg font-semibold text-white font-display flex items-center gap-2 mb-4">
              <span class="hero-shield-check w-5 h-5 text-emerald-400"></span> Compliance Check
            </h2>
            <div class="space-y-4">
              <div class="flex items-start gap-3">
                <span class="hero-check-circle w-5 h-5 text-emerald-400 shrink-0"></span>
                <div>
                  <p class="text-sm text-white">Drug Scheduling</p>
                  <p class="text-xs text-gray-500">Amoxicillin allowed (POM)</p>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <span class="hero-check-circle w-5 h-5 text-emerald-400 shrink-0"></span>
                <div>
                  <p class="text-sm text-white">Import License</p>
                  <p class="text-xs text-gray-500">Verified for Netherlands</p>
                </div>
              </div>
              <div class="flex items-start gap-3">
                <span class="hero-check-circle w-5 h-5 text-emerald-400 shrink-0"></span>
                <div>
                  <p class="text-sm text-white">EU FMD Serialisation</p>
                  <p class="text-xs text-gray-500">Barcodes valid</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Disruption Modal Overlay -->
      <%= if @disruption do %>
        <div class="fixed inset-0 bg-black/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
          <div class="glass-card w-full max-w-3xl p-6 border-red-500/30 shadow-[0_8px_40px_rgba(239,68,68,0.2)] animate-fade-in-up">
            <div class="flex items-center gap-3 mb-6">
              <div class="w-12 h-12 rounded-xl bg-red-500/20 flex items-center justify-center">
                <span class="hero-exclamation-triangle w-6 h-6 text-red-500"></span>
              </div>
              <div>
                <h2 class="text-xl font-bold text-white font-display">Disruption Detected</h2>
                <p class="text-red-400 text-sm font-medium">{@disruption.impact}</p>
              </div>
            </div>

            <p class="text-gray-300 text-sm mb-6">
              The AI Route Scorer has generated alternative constraint-aware routes to maintain your cold-chain and regulatory compliance.
            </p>

            <div class="space-y-4">
              <%= for route <- @scored_routes do %>
                <div class={"flex items-center justify-between p-4 rounded-xl border #{if route.id == @active_route.id, do: "bg-white/[0.05] border-gray-600", else: "bg-white/[0.02] border-white/[0.05] hover:border-accent/40"}"}>
                  <div class="flex-1">
                    <p class="text-white font-medium text-sm mb-1">{route.path}</p>
                    <div class="flex items-center gap-4 text-xs text-gray-400">
                      <span>
                        <span class="text-gray-500">Time:</span> {route.total_transit_days} days
                      </span>
                      <span><span class="text-gray-500">Cost:</span> ${route.total_cost}</span>
                      <%= if route.is_cold_chain_compliant do %>
                        <span class="text-emerald-400">
                          <span class="hero-sparkles-micro w-3 h-3 inline"></span> GDP Valid
                        </span>
                      <% else %>
                        <span class="text-red-400">
                          <span class="hero-x-circle-micro w-3 h-3 inline"></span> Non-GDP Hub
                        </span>
                      <% end %>
                      <%= if route.regulatory_risk_score > 0 do %>
                        <span class="text-amber-400">
                          <span class="hero-exclamation-circle-micro w-3 h-3 inline"></span> High Risk
                        </span>
                      <% end %>
                    </div>
                  </div>
                  <%= if route.id == @active_route.id do %>
                    <button class="btn-ghost opacity-50 cursor-not-allowed" disabled>Current</button>
                  <% else %>
                    <button phx-click="select_route" phx-value-id={route.id} class="btn-primary">
                      Select
                    </button>
                  <% end %>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  defp status_badge("In Transit"), do: "badge-success"
  defp status_badge("Delayed"), do: "badge-warning"
  defp status_badge("Critical"), do: "badge-danger"
  defp status_badge(_), do: "badge-info"
end
