defmodule RoutiqWeb.DashboardLive do
  use RoutiqWeb, :live_view

  alias Routiq.Compliance
  alias Routiq.Organizations

  @impl true
  def mount(_params, _session, socket) do
    substance_count = length(Compliance.list_substances())
    country_rule_count = length(Compliance.list_country_rules())
    org_count = length(Organizations.list_organizations())

    socket =
      socket
      |> assign(:page_title, "Dashboard")
      |> assign(:active_tab, :dashboard)
      |> assign(:substance_count, substance_count)
      |> assign(:country_rule_count, country_rule_count)
      |> assign(:org_count, org_count)
      |> assign(:recent_activities, build_recent_activities())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-8">
      <!-- Welcome header -->
      <div class="animate-fade-in-up">
        <h1 class="text-3xl font-bold text-white font-display tracking-tight">
          Welcome back<span class="text-accent">.</span>
        </h1>
        <p class="text-gray-400 mt-1.5 text-sm">
          Here's an overview of your pharmaceutical export compliance status.
        </p>
      </div>
      
    <!-- Stats Grid -->
      <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-5 stagger">
        <!-- Active Shipments -->
        <div class="stat-card animate-fade-in-up">
          <div class="stat-icon bg-gradient-to-br from-brand to-blue-600">
            <svg
              class="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M8.25 18.75a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h6m-9 0H3.375a1.125 1.125 0 0 1-1.125-1.125V14.25m17.25 4.5a1.5 1.5 0 0 1-3 0m3 0a1.5 1.5 0 0 0-3 0m3 0h1.125c.621 0 1.129-.504 1.09-1.124a17.902 17.902 0 0 0-3.213-9.193 2.056 2.056 0 0 0-1.58-.86H14.25M16.5 18.75h-2.25m0-11.177v-.958c0-.568-.422-1.048-.987-1.106a48.554 48.554 0 0 0-10.026 0 1.106 1.106 0 0 0-.987 1.106v7.635m12-6.677v6.677m0 4.5v-4.5m0 0h-12"
              />
            </svg>
          </div>
          <div class="stat-value">0</div>
          <div class="stat-label">Active Shipments</div>
          <div class="stat-trend up">
            <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M10 17a.75.75 0 01-.75-.75V5.612L5.29 9.77a.75.75 0 01-1.08-1.04l5.25-5.5a.75.75 0 011.08 0l5.25 5.5a.75.75 0 11-1.08 1.04l-3.96-4.158V16.25A.75.75 0 0110 17z"
                clip-rule="evenodd"
              />
            </svg>
            Ready to track
          </div>
          <!-- Decorative gradient -->
          <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-brand/20 rounded-full blur-2xl"></div>
        </div>
        
    <!-- Substances Tracked -->
        <div class="stat-card animate-fade-in-up">
          <div class="stat-icon bg-gradient-to-br from-emerald-600 to-emerald-400">
            <svg
              class="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M9.75 3.104v5.714a2.25 2.25 0 0 1-.659 1.591L5 14.5M9.75 3.104c-.251.023-.501.05-.75.082m.75-.082a24.301 24.301 0 0 1 4.5 0m0 0v5.714c0 .597.237 1.17.659 1.591L19.8 15.3M14.25 3.104c.251.023.501.05.75.082M19.8 15.3l-1.57.393A9.065 9.065 0 0 1 12 15a9.065 9.065 0 0 0-6.23.693L5 14.5m14.8.8 1.402 1.402c1.232 1.232.65 3.318-1.067 3.611A48.309 48.309 0 0 1 12 21c-2.773 0-5.491-.235-8.135-.687-1.718-.293-2.3-2.379-1.067-3.61L5 14.5"
              />
            </svg>
          </div>
          <div class="stat-value">{@substance_count}</div>
          <div class="stat-label">Tracked Substances</div>
          <div class="stat-trend up">
            <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M10 17a.75.75 0 01-.75-.75V5.612L5.29 9.77a.75.75 0 01-1.08-1.04l5.25-5.5a.75.75 0 011.08 0l5.25 5.5a.75.75 0 11-1.08 1.04l-3.96-4.158V16.25A.75.75 0 0110 17z"
                clip-rule="evenodd"
              />
            </svg>
            In database
          </div>
          <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-emerald-500/20 rounded-full blur-2xl">
          </div>
        </div>
        
    <!-- Country Rules -->
        <div class="stat-card animate-fade-in-up">
          <div class="stat-icon bg-gradient-to-br from-violet-600 to-violet-400">
            <svg
              class="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M12 21a9.004 9.004 0 0 0 8.716-6.747M12 21a9.004 9.004 0 0 1-8.716-6.747M12 21c2.485 0 4.5-4.03 4.5-9S14.485 3 12 3m0 18c-2.485 0-4.5-4.03-4.5-9S9.515 3 12 3m0 0a8.997 8.997 0 0 1 7.843 4.582M12 3a8.997 8.997 0 0 0-7.843 4.582m15.686 0A11.953 11.953 0 0 1 12 10.5c-2.998 0-5.74-1.1-7.843-2.918m15.686 0A8.959 8.959 0 0 1 21 12c0 .778-.099 1.533-.284 2.253m0 0A17.919 17.919 0 0 1 12 16.5c-3.162 0-6.133-.815-8.716-2.247m0 0A9.015 9.015 0 0 1 3 12c0-1.605.42-3.113 1.157-4.418"
              />
            </svg>
          </div>
          <div class="stat-value">{@country_rule_count}</div>
          <div class="stat-label">Country Rules</div>
          <div class="stat-trend up">
            <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
              <path
                fill-rule="evenodd"
                d="M10 17a.75.75 0 01-.75-.75V5.612L5.29 9.77a.75.75 0 01-1.08-1.04l5.25-5.5a.75.75 0 011.08 0l5.25 5.5a.75.75 0 11-1.08 1.04l-3.96-4.158V16.25A.75.75 0 0110 17z"
                clip-rule="evenodd"
              />
            </svg>
            Configured
          </div>
          <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-violet-500/20 rounded-full blur-2xl">
          </div>
        </div>
        
    <!-- Compliance Score -->
        <div class="stat-card animate-fade-in-up">
          <div class="stat-icon bg-gradient-to-br from-amber-600 to-amber-400">
            <svg
              class="w-6 h-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M9 12.75 11.25 15 15 9.75m-3-7.036A11.959 11.959 0 0 1 3.598 6 11.99 11.99 0 0 0 3 9.749c0 5.592 3.824 10.29 9 11.623 5.176-1.332 9-6.03 9-11.622 0-1.31-.21-2.571-.598-3.751h-.152c-3.196 0-6.1-1.248-8.25-3.285Z"
              />
            </svg>
          </div>
          <div class="stat-value">—</div>
          <div class="stat-label">Compliance Score</div>
          <div class="stat-trend text-gray-500">
            Awaiting first shipment
          </div>
          <div class="absolute -bottom-4 -right-4 w-24 h-24 bg-amber-500/20 rounded-full blur-2xl">
          </div>
        </div>
      </div>
      
    <!-- Two-column content -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Quick Actions -->
        <div class="glass-card p-6 animate-fade-in-up lg:col-span-1">
          <h2 class="text-lg font-semibold text-white font-display mb-5 flex items-center gap-2">
            <span class="hero-bolt w-5 h-5 text-accent"></span> Quick Actions
          </h2>
          <div class="space-y-3">
            <.link
              navigate={~p"/substances"}
              class="flex items-center gap-3 p-3 rounded-xl bg-white/[0.03] hover:bg-white/[0.07] border border-white/[0.05] hover:border-accent/30 transition-all duration-200 group"
            >
              <div class="w-10 h-10 rounded-lg bg-emerald-500/10 flex items-center justify-center group-hover:bg-emerald-500/20 transition-colors">
                <span class="hero-beaker w-5 h-5 text-emerald-400"></span>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Browse Substances</p>
                <p class="text-xs text-gray-500">View tracked substances</p>
              </div>
              <span class="hero-chevron-right w-4 h-4 text-gray-600 ml-auto group-hover:text-accent transition-colors">
              </span>
            </.link>

            <.link
              navigate={~p"/country-rules"}
              class="flex items-center gap-3 p-3 rounded-xl bg-white/[0.03] hover:bg-white/[0.07] border border-white/[0.05] hover:border-accent/30 transition-all duration-200 group"
            >
              <div class="w-10 h-10 rounded-lg bg-violet-500/10 flex items-center justify-center group-hover:bg-violet-500/20 transition-colors">
                <span class="hero-globe-alt w-5 h-5 text-violet-400"></span>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Country Rules</p>
                <p class="text-xs text-gray-500">Check import regulations</p>
              </div>
              <span class="hero-chevron-right w-4 h-4 text-gray-600 ml-auto group-hover:text-accent transition-colors">
              </span>
            </.link>

            <.link
              navigate={~p"/compliance"}
              class="flex items-center gap-3 p-3 rounded-xl bg-white/[0.03] hover:bg-white/[0.07] border border-white/[0.05] hover:border-accent/30 transition-all duration-200 group"
            >
              <div class="w-10 h-10 rounded-lg bg-sky-500/10 flex items-center justify-center group-hover:bg-sky-500/20 transition-colors">
                <span class="hero-shield-check w-5 h-5 text-sky-400"></span>
              </div>
              <div>
                <p class="text-sm font-medium text-white">Compliance Check</p>
                <p class="text-xs text-gray-500">Verify export readiness</p>
              </div>
              <span class="hero-chevron-right w-4 h-4 text-gray-600 ml-auto group-hover:text-accent transition-colors">
              </span>
            </.link>
          </div>
        </div>
        
    <!-- Recent Activity -->
        <div class="glass-card p-6 animate-fade-in-up lg:col-span-2">
          <h2 class="text-lg font-semibold text-white font-display mb-5 flex items-center gap-2">
            <span class="hero-clock w-5 h-5 text-accent"></span> Recent Activity
          </h2>

          <div class="space-y-4">
            <%= for activity <- @recent_activities do %>
              <div class="flex items-start gap-4 p-3 rounded-xl hover:bg-white/[0.03] transition-colors">
                <div class={"w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 #{activity.icon_bg}"}>
                  <span class={"#{activity.icon} w-4 h-4 #{activity.icon_color}"}></span>
                </div>
                <div class="flex-1 min-w-0">
                  <p class="text-sm text-white font-medium">{activity.title}</p>
                  <p class="text-xs text-gray-500 mt-0.5">{activity.description}</p>
                </div>
                <span class={"badge #{activity.badge_class}"}>{activity.badge}</span>
              </div>
            <% end %>
          </div>

          <%= if @recent_activities == [] do %>
            <div class="text-center py-12">
              <span class="hero-inbox w-12 h-12 text-gray-700 mx-auto"></span>
              <p class="text-gray-500 mt-3 text-sm">No recent activity</p>
              <p class="text-gray-600 text-xs mt-1">
                Activities will appear here as you use the platform
              </p>
            </div>
          <% end %>
        </div>
      </div>
      
    <!-- Compliance Matrix Preview -->
      <div class="glass-card p-6 animate-fade-in-up">
        <div class="flex items-center justify-between mb-5">
          <h2 class="text-lg font-semibold text-white font-display flex items-center gap-2">
            <span class="hero-table-cells w-5 h-5 text-accent"></span> Compliance Matrix
          </h2>
          <.link
            navigate={~p"/country-rules"}
            class="text-sm text-accent hover:text-white transition-colors font-medium"
          >
            View all →
          </.link>
        </div>

        <%= if @country_rule_count > 0 do %>
          <div class="overflow-x-auto">
            <p class="text-sm text-gray-400">
              {@country_rule_count} country rules configured across your tracked substances.
              Navigate to Country Rules for the full compliance matrix.
            </p>
          </div>
        <% else %>
          <div class="text-center py-8">
            <span class="hero-globe-alt w-10 h-10 text-gray-700 mx-auto"></span>
            <p class="text-gray-500 mt-3 text-sm">No compliance rules configured yet</p>
            <p class="text-gray-600 text-xs mt-1">
              Run
              <code class="text-accent/60 bg-accent/10 px-1 rounded">
                mix run priv/repo/seeds.exs
              </code>
              to seed demo data
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp build_recent_activities do
    [
      %{
        title: "Platform initialized",
        description: "Routiq PharmRoute compliance engine is ready",
        icon: "hero-rocket-launch",
        icon_bg: "bg-accent/10",
        icon_color: "text-accent",
        badge: "System",
        badge_class: "badge-info"
      },
      %{
        title: "Compliance database configured",
        description: "Substance and country rule schemas are active",
        icon: "hero-circle-stack",
        icon_bg: "bg-emerald-500/10",
        icon_color: "text-emerald-400",
        badge: "Ready",
        badge_class: "badge-success"
      },
      %{
        title: "Authentication engine active",
        description: "Role-based access control is operational",
        icon: "hero-shield-check",
        icon_bg: "bg-violet-500/10",
        icon_color: "text-violet-400",
        badge: "Active",
        badge_class: "badge-success"
      }
    ]
  end
end
