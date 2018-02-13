defmodule Bowling.Game do
  @opaque t :: list(non_neg_integer)
  def new do
    []
  end

  @spec throw(t, integer) :: t
  def throw(game, pins) do
    game ++ [pins]
  end

  def frames(game) do
    frames(game, [])
  end

  defp frames([], frames), do: frames

  defp frames([10 | rest], acc) do
    frames(rest, acc ++ [{length(acc), [10]}])
  end

  defp frames(throws, acc) do
    frame = Enum.slice(throws, 0..1)
    rest = Enum.slice(throws, 2..(length(throws) - 1))
    frames(rest, acc ++ [{length(acc), frame}])
  end

  @spec score(t) :: integer
  def score(game) do
    game
    |> frame_scores()
    |> Enum.filter(&(&1 != :unknown))
    |> sum()
  end

  defp sum([]), do: 0
  defp sum([head | tail]), do: head + sum(tail)

  defp chunk_frames([]), do: []
  defp chunk_frames([head | tail] = list), do: [list] ++ chunk_frames(tail)

  defp scored_frames(game) do
    game
    |> frames()
    |> chunk_frames()
    |> Enum.filter(&scored_frame?/1)
    |> Enum.map(fn([frame | _]) -> frame end)
  end

  defp frame_scores(game) do
    scores = game
    |> frames()
    |> chunk_frames()
    |> Enum.map(&frame_score/1)
  end

  defp spare_score(subsequent_frames) do
    subsequent_throws = subsequent_frames
    |> Enum.flat_map(fn({_id, throws}) -> throws end)

    if length(subsequent_throws) >= 1 do
      10 + sum(Enum.slice(subsequent_throws, 0..0))
    else
      :unknown
    end
  end

  defp strike_score(subsequent_frames) do
    subsequent_throws = subsequent_frames
    |> Enum.flat_map(fn({_id, throws}) -> throws end)

    if length(subsequent_throws) >= 2 do
      10 + sum(Enum.slice(subsequent_throws, 0..1))
    else
      :unknown
    end
  end

  defp frame_score(list) do
    [{frame, throws} | others] = list
    cond do
      !frame_over?({frame, throws}) -> :unknown
      throws == [10] -> strike_score(others)
      sum(throws) == 10 -> spare_score(others)
      true -> sum(throws)
    end
  end

  defp scored_frame?(list) do
    frame_score(list) != :unknown
  end

  defp frame_over?({_frame, [10]}), do: true
  defp frame_over?({_frame, throws}), do: length(throws) == 2

  @spec frame(t) :: integer
  def frame(game) do
    game
    |> frames()
    |> Enum.filter(&frame_over?/1)
    |> length
  end
end
