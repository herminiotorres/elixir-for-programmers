defmodule Hangman do
  alias Hangman.{Application, Server}
  @app __MODULE__.Supervisor

  def new_game(player) do
    Supervisor.start_child(@app, Server.child_spec(player))
  end

  def new_game() do
    Application.start(@app, [])
  end

  def tally(player \\ :guest) do
    GenServer.call(player, {:tally})
  end

  def make_move(player \\ :guest, guess) do
    GenServer.call(player, {:make_move, guess})
  end
end
