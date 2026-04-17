defmodule RoutiqWeb.CountryRuleLive.Index do
  use RoutiqWeb, :live_view

  alias Routiq.Compliance

  @impl true
  def mount(_params, _session, socket) do
    country_rules = Compliance.list_country_rules()
    substances = Compliance.list_substances()

    # Group rules by country
    grouped =
      country_rules
      |> Enum.group_by(& &1.country_code)
      |> Enum.sort_by(fn {code, _} -> code end)

    socket =
      socket
      |> assign(:page_title, "Country Rules")
      |> assign(:active_tab, :country_rules)
      |> assign(:country_rules, country_rules)
      |> assign(:grouped_rules, grouped)
      |> assign(:substances, substances)
      |> assign(:selected_country, nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("select_country", %{"code" => code}, socket) do
    selected = if socket.assigns.selected_country == code, do: nil, else: code
    {:noreply, assign(socket, :selected_country, selected)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header -->
      <div class="animate-fade-in-up">
        <h1 class="text-2xl font-bold text-white font-display tracking-tight">
          Country Rules<span class="text-accent">.</span>
        </h1>
        <p class="text-gray-400 text-sm mt-1">
          Import regulations and schedule classifications by country
        </p>
      </div>

      <!-- Country cards grid -->
      <%= if @grouped_rules != [] do %>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 stagger">
          <%= for {country_code, rules} <- @grouped_rules do %>
            <button
              phx-click="select_country"
              phx-value-code={country_code}
              class={"glass-card p-5 text-left transition-all duration-200 animate-fade-in-up cursor-pointer #{if @selected_country == country_code, do: "border-accent/40 shadow-accent/10 shadow-lg", else: ""}"}
            >
              <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-3">
                  <div class="w-10 h-10 rounded-xl bg-violet-500/10 flex items-center justify-center text-lg">
                    <%= country_flag(country_code) %>
                  </div>
                  <div>
                    <h3 class="text-white font-semibold text-sm"><%= country_name(country_code) %></h3>
                    <p class="text-gray-500 text-xs"><%= country_code %></p>
                  </div>
                </div>
                <span class="badge badge-info"><%= length(rules) %> rules</span>
              </div>

              <div class="flex flex-wrap gap-1.5 mt-2">
                <%= for rule <- Enum.take(rules, 3) do %>
                  <span class={"text-[10px] px-2 py-0.5 rounded-full #{schedule_class_style(rule.schedule_class)}"}>
                    <%= rule.schedule_class %>
                  </span>
                <% end %>
                <%= if length(rules) > 3 do %>
                  <span class="text-[10px] px-2 py-0.5 rounded-full bg-white/[0.05] text-gray-400">
                    +<%= length(rules) - 3 %> more
                  </span>
                <% end %>
              </div>
            </button>
          <% end %>
        </div>

        <!-- Expanded rules table -->
        <%= if @selected_country do %>
          <div class="glass-card overflow-hidden animate-fade-in-up">
            <div class="px-6 py-4 border-b border-white/[0.06] flex items-center justify-between">
              <h2 class="text-white font-semibold font-display flex items-center gap-2">
                <span class="text-xl"><%= country_flag(@selected_country) %></span>
                <%= country_name(@selected_country) %> — Detailed Rules
              </h2>
              <button phx-click="select_country" phx-value-code={@selected_country} class="text-gray-400 hover:text-white transition-colors">
                <span class="hero-x-mark w-5 h-5"></span>
              </button>
            </div>
            <div class="overflow-x-auto">
              <table class="data-table">
                <thead>
                  <tr>
                    <th>Schedule Class</th>
                    <th>Import Permit</th>
                    <th>Quantity Limits</th>
                    <th>Labelling Rules</th>
                    <th>Effective Date</th>
                    <th>Source</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for rule <- Map.get(Enum.into(@grouped_rules, %{}), @selected_country, []) do %>
                    <tr>
                      <td>
                        <span class={"badge #{schedule_class_badge(rule.schedule_class)}"}><%= rule.schedule_class %></span>
                      </td>
                      <td>
                        <%= if rule.import_permit_required do %>
                          <span class="badge badge-warning">Required</span>
                        <% else %>
                          <span class="badge badge-success">Not required</span>
                        <% end %>
                      </td>
                      <td class="text-gray-300 text-xs max-w-[200px] truncate" title={rule.quantity_limits}><%= rule.quantity_limits %></td>
                      <td class="text-gray-300 text-xs max-w-[200px] truncate" title={rule.labelling_rules}><%= rule.labelling_rules %></td>
                      <td class="text-gray-400 text-xs"><%= rule.effective_date %></td>
                      <td>
                        <%= if rule.source_url && rule.source_url != "" do %>
                          <a href={rule.source_url} target="_blank" class="text-accent hover:text-white text-xs transition-colors flex items-center gap-1">
                            <span class="hero-arrow-top-right-on-square-mini w-3 h-3"></span>
                            Source
                          </a>
                        <% else %>
                          <span class="text-gray-600 text-xs">—</span>
                        <% end %>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        <% end %>
      <% else %>
        <div class="glass-card p-12 text-center animate-fade-in-up">
          <span class="hero-globe-alt w-12 h-12 text-gray-700 mx-auto"></span>
          <p class="text-gray-500 mt-4 text-sm">No country rules configured</p>
          <p class="text-gray-600 text-xs mt-1">
            Run <code class="text-accent/60 bg-accent/10 px-1.5 py-0.5 rounded">mix run priv/repo/seeds.exs</code> to load demo data
          </p>
        </div>
      <% end %>
    </div>
    """
  end

  # Helpers
  defp country_flag("US"), do: "🇺🇸"
  defp country_flag("GB"), do: "🇬🇧"
  defp country_flag("DE"), do: "🇩🇪"
  defp country_flag("JP"), do: "🇯🇵"
  defp country_flag("AU"), do: "🇦🇺"
  defp country_flag("BR"), do: "🇧🇷"
  defp country_flag("IN"), do: "🇮🇳"
  defp country_flag("ZA"), do: "🇿🇦"
  defp country_flag("AE"), do: "🇦🇪"
  defp country_flag("KE"), do: "🇰🇪"
  defp country_flag("NG"), do: "🇳🇬"
  defp country_flag(_), do: "🌍"

  defp country_name("US"), do: "United States"
  defp country_name("GB"), do: "United Kingdom"
  defp country_name("DE"), do: "Germany"
  defp country_name("JP"), do: "Japan"
  defp country_name("AU"), do: "Australia"
  defp country_name("BR"), do: "Brazil"
  defp country_name("IN"), do: "India"
  defp country_name("ZA"), do: "South Africa"
  defp country_name("AE"), do: "UAE"
  defp country_name("KE"), do: "Kenya"
  defp country_name("NG"), do: "Nigeria"
  defp country_name(code), do: code

  defp schedule_class_style("Schedule II"), do: "bg-red-500/20 text-red-400"
  defp schedule_class_style("Schedule III"), do: "bg-amber-500/20 text-amber-400"
  defp schedule_class_style("Schedule IV"), do: "bg-yellow-500/20 text-yellow-400"
  defp schedule_class_style("Schedule V"), do: "bg-emerald-500/20 text-emerald-400"
  defp schedule_class_style("OTC"), do: "bg-sky-500/20 text-sky-400"
  defp schedule_class_style("Unscheduled"), do: "bg-gray-500/20 text-gray-400"
  defp schedule_class_style(_), do: "bg-white/10 text-gray-300"

  defp schedule_class_badge("Schedule II"), do: "badge-danger"
  defp schedule_class_badge("Schedule III"), do: "badge-warning"
  defp schedule_class_badge("Schedule IV"), do: "badge-warning"
  defp schedule_class_badge("Schedule V"), do: "badge-success"
  defp schedule_class_badge("OTC"), do: "badge-info"
  defp schedule_class_badge(_), do: "badge-info"
end
