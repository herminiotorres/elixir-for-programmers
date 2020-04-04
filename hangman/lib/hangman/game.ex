defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new(),
  )

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints
    }
  end

  def new_game() do
    new_game(Dictionary.random_word)
  end

  def move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
  end

  def move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters |> reveal_guessed(game.used),
    }
  end

  def make_move(game, guess) do
    case String.match?(guess, ~r/^[[:lower:]]{1}$/u) do
      true ->
        {
          move(game, guess),
          tally(game)
        }
      _ -> "Error: Only matches one letter from A–Z in lowercase."
    end
  end

  #def is_guess_valid?(guess), do: guess |> String.match?(~r/^[[:lower:]]{1}$/u)

  defp accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
                |> MapSet.subset?(game.used)
                |> maybe_won()
    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game = %{turns_left: 1}, _not_good_guess) do
    %{
      game |
      game_state: :lost,
      turns_left: 0
    }
  end

  defp score_guess(game = %{turns_left: turns_left}, _not_good_guess) do
    %{
      game |
      game_state: :bad_guess,
      turns_left: turns_left - 1
    }
  end

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(letter, _not_in_word),    do: "_"

  defp maybe_won(true), do: :won
  defp maybe_won(_),    do: :good_guess
end
