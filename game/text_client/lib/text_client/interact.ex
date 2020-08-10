defmodule TextClient.Interact do
  @doc """

    # Hangman Node:
    game/hangman$ iex --sname hangman -S mix

    iex(hangman@nitro)[1]> :observer.start
    :ok

    # TextClient Node:
    game/text_client$ iex --sname c1 -S mix

    iex(c1@nitro)[1]> TextClient.start

    Word so far: _ _ _ _ _ _ _
    Guesses left: 7

  """

  alias TextClient.{Player, State}

  # @nitro -> its because my machine its called nitro!
  @hangman_server :hangman@nitro

  def start() do
    {:ok, game} = new_game()

    game
    |> setup_state()
    |> Player.play()
  end

  def play(state) do
    play(state)
  end

  defp setup_state(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end

  # http://erlang.org/doc/man/rpc.html
  # iex> node()
  # client@nitro
  defp new_game() do
    Node.connect(@hangman_server)

    :rpc.call(@hangman_server,
      Hangman,
      :new_game,
      [node()]
    )
  end
end
