defmodule ElixslxTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ElixslxTest.Repo,
      # Start the Telemetry supervisor
      ElixslxTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixslxTest.PubSub},
      # Start the Endpoint (http/https)
      ElixslxTestWeb.Endpoint
      # Start a worker by calling: ElixslxTest.Worker.start_link(arg)
      # {ElixslxTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixslxTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixslxTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
