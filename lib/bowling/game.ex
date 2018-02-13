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

  defp frames([10 | rest] = list, acc) do
    frame_index = length(acc)
    case frame_index do
      9 -> acc ++ [{frame_index, list}]
      _ -> frames(rest, acc ++ [{frame_index, [10]}])
    end
  end

  defp frames(throws, acc) do
    frame_index = length(acc)

    case frame_index do
      9 -> acc ++ [{frame_index, throws}]
      _ ->
        frame = Enum.slice(throws, 0..1)
        rest = Enum.slice(throws, 2..(length(throws) - 1))
        frames(rest, acc ++ [{frame_index, frame}])
    end
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
  defp chunk_frames([_head | tail] = list), do: [list] ++ chunk_frames(tail)

  defp frame_scores(game) do
    game
    |> frames()
    |> chunk_frames()
    |> Enum.map(&frame_score/1)
  end

  defp spare_score(subsequent_throws) do
    if length(subsequent_throws) >= 1 do
      10 + sum(Enum.slice(subsequent_throws, 0..0))
    else
      :unknown
    end
  end

  defp strike_score(subsequent_throws) do
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
      Enum.at(throws, 0) == 10 ->
        [10 | rest] = throws
        subsequent_throws = others
        |> Enum.flat_map(fn({_id, throws}) -> throws end)

        strike_score(rest ++ subsequent_throws)
      sum(Enum.slice(throws, 0..1)) == 10 ->
        subsequent_throws = others
        |> Enum.flat_map(fn({_id, throws}) -> throws end)

        spare_score(Enum.slice(throws, 2..2) ++ subsequent_throws)
      true ->
        sum(throws)
    end
  end

  defp frame_over?({9, [10]}), do: false
  defp frame_over?({9, [10, _]}), do: false
  defp frame_over?({9, [10, _, _]}), do: true
  defp frame_over?({9, throws}) when length(throws) == 2 do
    sum(throws) != 10
  end
  defp frame_over?({_frame, [10]}), do: true
  defp frame_over?({_frame, throws}), do: length(throws) >= 2

  @spec frame(t) :: integer
  def frame(game) do
    number = game
    |> frames()
    |> Enum.filter(&frame_over?/1)
    |> length

    if number > 9, do: :over, else: number
  end
end
