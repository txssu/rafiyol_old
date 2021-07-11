defmodule Rafiyol.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Rafiyol.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Rafiyol.PubSub}
      # Start a worker by calling: Rafiyol.Worker.start_link(arg)
      # {Rafiyol.Worker, arg}
    ]

    Rafiyol.LearnSession.init()

    Supervisor.start_link(children, strategy: :one_for_one, name: Rafiyol.Supervisor)
  end
end
