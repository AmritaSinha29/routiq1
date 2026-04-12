defmodule Routiq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      RoutiqWeb.Telemetry,
      Routiq.Repo,
      {DNSCluster, query: Application.get_env(:routiq, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Routiq.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Routiq.Finch},
      # Start a worker by calling: Routiq.Worker.start_link(arg)
      # {Routiq.Worker, arg},
      # Start to serve requests, typically the last entry
      RoutiqWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Routiq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RoutiqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
