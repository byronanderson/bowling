defmodule BowlingGameTest do
  use ExUnit.Case

  alias Bowling.Game

  test "starts with no score in the first frame" do
    game = Game.new()
    assert Game.score(game) == 0
    assert Game.frame(game) == 0
  end

  test "can increment score after a frame is no longer outstanding" do
    game = Game.new()
           |> Game.throw(1)
           |> Game.throw(1)

    assert Game.frames(game) == [
      {0, [1, 1]}
    ]
    assert Game.score(game) == 2
    assert Game.frame(game) == 1
  end

  test "it is still the first frame after one throw" do
    game = Game.new()
           |> Game.throw(1)

    assert Game.frame(game) == 0
    assert Game.score(game) == 0
  end

  test "it advances the frame after a strike" do
    game = Game.new()
           |> Game.throw(10)

    assert Game.frame(game) == 1
    assert Game.score(game) == 0
  end

  test "it scores a strike after two more throws" do
    game = Game.new()
           |> Game.throw(10)
           |> Game.throw(1)
           |> Game.throw(1)

    assert Game.frame(game) == 2
    assert Game.score(game) == 14
  end

  test "handles a turkey" do
    game = Game.new()
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)

    assert Game.frame(game) == 3
    assert Game.score(game) == 30
  end

  test "it scores a spare after one more throw" do
    game = Game.new()
           |> Game.throw(9)
           |> Game.throw(1)
           |> Game.throw(1)

    assert Game.frame(game) == 1
    assert Game.score(game) == 11
  end

  test "the game can end" do
    game = Game.new()
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)

    assert Game.score(game) == 20
    assert Game.frame(game) == :over
  end

  test "the game can end on a turkey" do
    game = Game.new()
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(10)

    assert Game.score(game) == 18
    assert Game.frame(game) == 9

    game = game
           |> Game.throw(10)

    assert Game.score(game) == 18
    assert Game.frame(game) == 9

    game = game
           |> Game.throw(10)

    assert Game.frame(game) == :over
    assert Game.score(game) == 48
  end

  test "the game can end with a spare" do
    game = Game.new()
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(1)
           |> Game.throw(9)

    assert Game.score(game) == 18
    assert Game.frame(game) == 9

    game = game
           |> Game.throw(1)

    assert Game.score(game) == 18
    assert Game.frame(game) == 9

    game = game
           |> Game.throw(10)

    assert Game.frame(game) == :over
    assert Game.score(game) == 38
  end

  test "perfect game" do
    game = Game.new()
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)
           |> Game.throw(10)

    assert Game.score(game) == 300
    assert Game.frame(game) == :over
  end
end
