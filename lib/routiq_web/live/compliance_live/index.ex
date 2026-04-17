defmodule RoutiqWeb.ComplianceLive.Index do
  use RoutiqWeb, :live_view

  alias Routiq.Compliance

  @impl true
  def mount(_params, _session, socket) do
    substances = Compliance.list_substances()
    country_rules = Compliance.list_country_rules()

    # Build compliance matrix: substance × country
    countries =
      country_rules
      |> Enum.map(& &1.country_code)
      |> Enum.uniq()
      |> Enum.sort()

    matrix =
      for substance <- substances do
        rules =
          country_rules
          |> Enum.filter(&(&1.substance_id == substance.id))
          |> Enum.into(%{}, fn r -> {r.country_code, r} end)

        %{substance: substance, rules: rules}
      end

    socket =
      socket
      |> assign(:page_title, "Compliance")
      |> assign(:active_tab, :compliance)
      |> assign(:substances, substances)
      |> assign(:countries, countries)
      |> assign(:matrix, matrix)

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <!-- Header -->
      <div class="animate-fade-in-up">
        <h1 class="text-2xl font-bold text-white font-display tracking-tight">
          Compliance Matrix<span class="text-accent">.</span>
        </h1>
        <p class="text-gray-400 text-sm mt-1">
          Cross-reference substance regulations across destination countries
        </p>
      </div>
      
    <!-- Legend -->
      <div class="glass-card p-4 animate-fade-in-up">
        <div class="flex flex-wrap items-center gap-4 text-xs">
          <span class="text-gray-500 font-medium">Legend:</span>
          <div class="flex items-center gap-1.5">
            <div class="w-3 h-3 rounded bg-emerald-500/40"></div>
            <span class="text-gray-400">No permit required</span>
          </div>
          <div class="flex items-center gap-1.5">
            <div class="w-3 h-3 rounded bg-amber-500/40"></div>
            <span class="text-gray-400">Permit required</span>
          </div>
          <div class="flex items-center gap-1.5">
            <div class="w-3 h-3 rounded bg-gray-700"></div>
            <span class="text-gray-400">No data</span>
          </div>
        </div>
      </div>
      
    <!-- Matrix -->
      <%= if @matrix != [] && @countries != [] do %>
        <div class="glass-card overflow-hidden animate-fade-in-up">
          <div class="overflow-x-auto">
            <table class="w-full">
              <thead>
                <tr class="border-b border-white/[0.06]">
                  <th class="text-xs font-semibold text-gray-500 uppercase tracking-wider px-4 py-3 text-left sticky left-0 bg-[#0F172A]/90 backdrop-blur-sm z-10 min-w-[200px]">
                    Substance
                  </th>
                  <%= for country <- @countries do %>
                    <th class="text-xs font-semibold text-gray-500 uppercase tracking-wider px-3 py-3 text-center min-w-[100px]">
                      <div class="flex flex-col items-center gap-1">
                        <span class="text-base">{country_flag(country)}</span>
                        <span>{country}</span>
                      </div>
                    </th>
                  <% end %>
                </tr>
              </thead>
              <tbody>
                <%= for row <- @matrix do %>
                  <tr class="border-b border-white/[0.04] hover:bg-white/[0.02] transition-colors">
                    <td class="px-4 py-3 sticky left-0 bg-[#0F172A]/90 backdrop-blur-sm z-10">
                      <div class="flex items-center gap-2">
                        <span class="hero-beaker-mini w-4 h-4 text-emerald-400"></span>
                        <div>
                          <p class="text-sm font-medium text-white">{row.substance.name}</p>
                          <p class="text-[10px] text-gray-500">{row.substance.cas_number}</p>
                        </div>
                      </div>
                    </td>
                    <%= for country <- @countries do %>
                      <td class="px-3 py-3 text-center">
                        <%= if rule = Map.get(row.rules, country) do %>
                          <div class={"inline-flex flex-col items-center gap-1 px-2 py-1.5 rounded-lg #{if rule.import_permit_required, do: "bg-amber-500/10", else: "bg-emerald-500/10"}"}>
                            <span class={"text-[10px] font-semibold #{if rule.import_permit_required, do: "text-amber-400", else: "text-emerald-400"}"}>
                              {rule.schedule_class}
                            </span>
                            <%= if rule.import_permit_required do %>
                              <span class="hero-exclamation-triangle-mini w-3 h-3 text-amber-400">
                              </span>
                            <% else %>
                              <span class="hero-check-circle-mini w-3 h-3 text-emerald-400"></span>
                            <% end %>
                          </div>
                        <% else %>
                          <div class="inline-flex items-center justify-center w-8 h-8 rounded-lg bg-gray-800/50">
                            <span class="hero-minus-mini w-4 h-4 text-gray-600"></span>
                          </div>
                        <% end %>
                      </td>
                    <% end %>
                  </tr>
                <% end %>
              </tbody>
            </table>
          </div>
        </div>
      <% else %>
        <div class="glass-card p-12 text-center animate-fade-in-up">
          <span class="hero-table-cells w-12 h-12 text-gray-700 mx-auto"></span>
          <p class="text-gray-500 mt-4 text-sm">Compliance matrix requires data</p>
          <p class="text-gray-600 text-xs mt-1">
            Seed substances and country rules to view the compliance matrix
          </p>
        </div>
      <% end %>
    </div>
    """
  end

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
end
