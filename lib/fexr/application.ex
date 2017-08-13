defmodule Fexr.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      supervisor(FexrWeb.Endpoint, []),
      # Start your own worker by calling: Fexr.Worker.start_link(arg1, arg2, arg3)
      # worker(Fexr.Worker, [arg1, arg2, arg3]),
      # Start ConCache
      supervisor(ConCache, [[ttl_check: :timer.seconds(1), ttl: :timer.seconds(5)], [name: :latest]],[ id: :latest, modules: [ConCache]]),
	    supervisor(ConCache, [[ttl_check: :timer.seconds(10800), ttl: :timer.hours(720)], [name: :historical]],[ id: :historical, modules: [ConCache]]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fexr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FexrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
