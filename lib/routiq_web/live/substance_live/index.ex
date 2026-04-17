defmodule RoutiqWeb.SubstanceLive.Index do
  use RoutiqWeb, :live_view

  alias Routiq.Compliance

  @impl true
  def mount(_params, _session, socket) do
    substances = Compliance.list_substances()

    socket =
      socket
      |> assign(:page_title, "Substances")
      |> assign(:active_tab, :substances)
      |> assign(:substances, substances)
      |> assign(:search, "")

    {:ok, socket}
  end

  @impl true
  def handle_event("search", %{"search" => search}, socket) do
    substances =
      Compliance.list_substances()
      |> Enum.filter(fn s ->
        term = String.downcase(search)
        String.contains?(String.downcase(s.name), term) ||
        String.contains?(String.downcase(s.cas_number || ""), term) ||
        String.contains?(String.downcase(s.type || ""), term)
      end)

    {:noreply, assign(socket, substances: substances, search: search)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header -->
      <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 animate-fade-in-up">
        <div>
          <h1 class="text-2xl font-bold text-white font-display tracking-tight">
            Substances<span class="text-accent">.</span>
          </h1>
          <p class="text-gray-400 text-sm mt-1">
            <%= length(@substances) %> tracked pharmaceutical substances
          </p>
        </div>
      </div>

      <!-- Search -->
      <div class="glass-card p-4 animate-fade-in-up">
        <form phx-change="search" class="flex items-center gap-3">
          <span class="hero-magnifying-glass w-5 h-5 text-gray-500"></span>
          <input
            type="text"
            name="search"
            value={@search}
            placeholder="Search substances by name, CAS number, or type..."
            class="flex-1 bg-transparent border-none text-white placeholder-gray-600 text-sm focus:ring-0 focus:outline-none"
            phx-debounce="300"
          />
        </form>
      </div>

      <!-- Table -->
      <div class="glass-card overflow-hidden animate-fade-in-up">
        <%= if @substances != [] do %>
          <div class="overflow-x-auto">
            <table class="data-table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>CAS Number</th>
                  <th>INN Name</th>
                  <th>Type</th>
                  <th>Properties</th>
                </tr>
              </thead>
              <tbody>
                <%= for substance <- @substances do %>
                  <tr>
                    <td>
                      <div class="flex items-center gap-3">
                        <div class="w-8 h-8 rounded-lg bg-emerald-500/10 flex items-center justify-center flex-shrink-0">
                          <span class="hero-beaker-mini w-4 h-4 text-emerald-400"></span>
                        </div>
                        <span class="font-medium text-white"><%= substance.name %></span>
                      </div>
                    </td>
                    <td>
                      <code class="text-xs bg-white/[0.05] px-2 py-1 rounded text-accent"><%= substance.cas_number %></code>
                    </td>
                    <td class="text-gray-300"><%= substance.inn_name %></td>
                    <td>
                      <span class={"badge #{type_badge_class(substance.type)}"}><%= substance.type %></span>
                    </td>
                    <td>
                      <%= if substance.properties && map_size(substance.properties) > 0 do %>
                        <span class="text-xs text-gray-500"><%= map_size(substance.properties) %> properties</span>
                      <% else %>
                        <span class="text-xs text-gray-600">—</span>
                      <% end %>
                    </td>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        <% else %>
          <div class="text-center py-16">
            <span class="hero-beaker w-12 h-12 text-gray-700 mx-auto"></span>
            <p class="text-gray-500 mt-4 text-sm">No substances found</p>
            <p class="text-gray-600 text-xs mt-1">
              Run <code class="text-accent/60 bg-accent/10 px-1.5 py-0.5 rounded">mix run priv/repo/seeds.exs</code> to load demo data
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp type_badge_class("API"), do: "badge-success"
  defp type_badge_class("Excipient"), do: "badge-info"
  defp type_badge_class("Controlled"), do: "badge-danger"
  defp type_badge_class("Narcotic"), do: "badge-danger"
  defp type_badge_class("Psychotropic"), do: "badge-warning"
  defp type_badge_class(_), do: "badge-info"
end
