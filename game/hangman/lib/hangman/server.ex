defmodule Hangman.Server do
  use GenServer
  alias Hangman.Game

  def start_link(player) do
    GenServer.start_link(__MODULE__, nil, name: player)
  end

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: :guest)
  end

  def init(_) do
    {:ok, Game.new_game()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {game, tally} = Game.make_move(game, guess)
    {:reply, tally, game}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end

  def child_spec(player) do
    %{
      id: player,
      start: {__MODULE__, :start_link, [player]}
    }
  end

  def child_spec() do
    %{id: :guest, start: {__MODULE__, :start_link, []}}
  end
end
