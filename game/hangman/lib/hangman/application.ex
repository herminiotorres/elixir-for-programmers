defmodule Hangman.Application do
  use Application
  alias Hangman.Server

  def start(_type, _args) do
    children = [
      {Server, :guest}
    ]

    options = [
      strategy: :one_for_one,
      name: Hangman.Supervisor,
    ]

    Supervisor.start_link(children, options)
  end
end
