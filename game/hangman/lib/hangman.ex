defmodule Hangman do
  def new_name() do
    {:ok, game_pid} = Supervisor.start_child(Hangman.Supervisor, [])
    game_pid
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end
end
