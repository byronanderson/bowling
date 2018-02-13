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
end
