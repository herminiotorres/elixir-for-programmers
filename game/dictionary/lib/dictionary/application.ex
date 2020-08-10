defmodule Dictionary.Application do
  use Application
  alias Dictionary.WordList

  def start(_type, _args) do
    children = [
      WordList
    ]

    opts = [ strategy: :one_for_one, name: Dictionary.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
