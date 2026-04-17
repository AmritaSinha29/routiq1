defmodule RoutiqWeb.ShipmentLive.Index do
  use RoutiqWeb, :live_view

  alias Routiq.Logistics

  @impl true
  def mount(_params, _session, socket) do
    # Fetch shipments or use an empty list if none exist
    shipments = Logistics.list_shipments()

    socket =
      socket
      |> assign(:page_title, "Shipments")
      |> assign(:active_tab, :shipments)
      |> assign(:shipments, shipments)

    {:ok, socket}
  end

  @impl true
  def handle_event("create_demo_shipment", _, socket) do
    # Creates a demo shipment for the hackathon scenario
    {:ok, _shipment} =
      Logistics.create_shipment(%{
        origin: "Ahmedabad, India (JNPT)",
        destination: "Rotterdam, Netherlands",
        status: "In Transit",
        tracking_number: "PR-EU-#{Enum.random(1000..9999)}",
        temperature_constraint: "2-8°C (Cold Chain)",
        compliance_status: "Verified",
        manifest_data: %{
          "product" => "Amoxicillin-Clavulanate 625mg",
          "quantity" => "10,000 packs",
          "apis" => ["Amoxicillin Trihydrate", "Clavulanate Potassium"]
        }
      })

    {:noreply,
     socket
     |> put_flash(:info, "Demo shipment created successfully.")
     |> assign(:shipments, Logistics.list_shipments())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 animate-fade-in-up">
        <div>
          <h1 class="text-2xl font-bold text-white font-display tracking-tight">
            Shipments<span class="text-accent">.</span>
          </h1>
          <p class="text-gray-400 text-sm mt-1">
            Track and manage pharmaceutical export shipments
          </p>
        </div>
        <button phx-click="create_demo_shipment" class="btn-primary flex items-center gap-2">
          <span class="hero-plus w-4 h-4"></span> New Demo Shipment
        </button>
      </div>
      
    <!-- Shipments List -->
      <div class="glass-card overflow-hidden animate-fade-in-up">
        <%= if @shipments != [] do %>
          <div class="overflow-x-auto">
            <table class="data-table">
              <thead>
                <tr>
                  <th>Tracking #</th>
                  <th>Route</th>
                  <th>Product</th>
                  <th>Constraints</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <%= for shipment <- @shipments do %>
                  <tr>
                    <td>
                      <div class="flex items-center gap-2">
                        <span class="hero-truck w-4 h-4 text-brand"></span>
                        <span class="font-medium text-white">{shipment.tracking_number}</span>
                      </div>
                    </td>
                    <td>
                      <div class="flex items-center gap-2 text-sm text-gray-300">
                        <span class="truncate max-w-[120px]" title={shipment.origin}>
                          {shipment.origin}
                        </span>
                        <span class="hero-arrow-right w-3 h-3 text-gray-500"></span>
                        <span class="truncate max-w-[120px]" title={shipment.destination}>
                          {shipment.destination}
                        </span>
                      </div>
                    </td>
                    <td>
                      <p class="text-sm text-white">{shipment.manifest_data["product"]}</p>
                      <p class="text-[10px] text-gray-500">{shipment.manifest_data["quantity"]}</p>
                    </td>
                    <td>
                      <span class="badge badge-info flex items-center gap-1 w-max">
                        <span class="hero-sparkles-mini w-3 h-3"></span>
                        {shipment.temperature_constraint}
                      </span>
                    </td>
                    <td>
                      <span class={"badge #{status_badge(shipment.status)}"}>
                        {shipment.status}
                      </span>
                    </td>
                    <td>
                      <.link
                        navigate={~p"/shipments/#{shipment.id}"}
                        class="text-accent hover:text-white text-sm font-medium transition-colors"
                      >
                        View Details →
                      </.link>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        <% else %>
          <div class="text-center py-16">
            <div class="w-20 h-20 rounded-2xl bg-gradient-to-br from-brand/20 to-accent/20 flex items-center justify-center mx-auto mb-6">
              <span class="hero-truck w-10 h-10 text-accent"></span>
            </div>
            <h2 class="text-xl font-bold text-white font-display mb-2">No Active Shipments</h2>
            <p class="text-gray-400 text-sm max-w-md mx-auto">
              Create a new demo shipment to see the AI Manifest Parsing, Compliance Check, and Route Disruption Engine in action.
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp status_badge("In Transit"), do: "badge-success"
  defp status_badge("Delayed"), do: "badge-warning"
  defp status_badge("Critical"), do: "badge-danger"
  defp status_badge(_), do: "badge-info"
end
