defmodule RoutiqWeb.ShipmentLive.Index do
  use RoutiqWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Shipments")
      |> assign(:active_tab, :shipments)

    {:ok, socket}
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
        <button class="btn-primary flex items-center gap-2" disabled>
          <span class="hero-plus w-4 h-4"></span>
          New Shipment
        </button>
      </div>

      <!-- Coming soon state -->
      <div class="glass-card p-16 text-center animate-fade-in-up">
        <div class="w-20 h-20 rounded-2xl bg-gradient-to-br from-brand/20 to-accent/20 flex items-center justify-center mx-auto mb-6">
          <svg class="w-10 h-10 text-accent" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12" />
          </svg>
        </div>
        <h2 class="text-xl font-bold text-white font-display mb-2">Shipment Tracking</h2>
        <p class="text-gray-400 text-sm max-w-md mx-auto">
          Shipment creation and tracking is coming in the next phase. 
          You'll be able to create manifests, run compliance checks, and track shipments in real-time.
        </p>
        <div class="flex items-center justify-center gap-3 mt-8">
          <div class="flex items-center gap-2 text-xs text-gray-500 bg-white/[0.03] px-4 py-2 rounded-lg border border-white/[0.06]">
            <span class="hero-beaker-mini w-4 h-4 text-emerald-400"></span>
            Manifest Intelligence
          </div>
          <div class="flex items-center gap-2 text-xs text-gray-500 bg-white/[0.03] px-4 py-2 rounded-lg border border-white/[0.06]">
            <span class="hero-shield-check-mini w-4 h-4 text-violet-400"></span>
            Auto Compliance
          </div>
          <div class="flex items-center gap-2 text-xs text-gray-500 bg-white/[0.03] px-4 py-2 rounded-lg border border-white/[0.06]">
            <span class="hero-map-pin-mini w-4 h-4 text-sky-400"></span>
            Route Tracking
          </div>
        </div>
      </div>
    </div>
    """
  end
end
