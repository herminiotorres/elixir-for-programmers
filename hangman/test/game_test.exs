defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.letters |> List.to_string |> String.match?(~r/^[[:lower:]]+$/u)
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)

      assert ^game = Game.move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.move(game, "x")
    assert game.game_state != :already_used
  end

  test "catch a error when pass the value of guess no equal then one letter from A-Z in lowercase" do
    game = Game.new_game("abc")
    error_message = Game.make_move(game, "X")
    assert error_message == "Error: Only matches one letter from A–Z in lowercase."
  end

  test "return a move when pass the value of guess equal then one letter from A-Z in lowercase" do
    game = Game.new_game("abc")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
  end

  test "second occurrence of letter is not already used" do
    game = Game.new_game()
    game = Game.move(game, "x")
    assert game.game_state != :already_used
    game = Game.move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guessed word is a won game" do
    moves = [
      {"w", :good_guess, 7},
      {"i", :good_guess, 7},
      {"b", :good_guess, 7},
      {"l", :good_guess, 7},
      {"e", :won, 7},
    ]

    game = Game.new_game("wibble")

    Enum.reduce(moves, game, fn ({guess, game_state, turns_left}, game) ->
      game = Game.move(game, guess)

      assert game.game_state == game_state
      assert game.turns_left == turns_left

      game
    end)
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    moves = [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"d", :bad_guess, 3},
      {"e", :bad_guess, 2},
      {"f", :bad_guess, 1},
      {"g", :lost, 0},
    ]
    game = Game.new_game("w")

    Enum.reduce(moves, game, fn ({guess, game_state, turns_left}, game) ->
      game = Game.move(game, guess)

      assert game.game_state == game_state
      assert game.turns_left == turns_left

      game
    end)
  end
end
