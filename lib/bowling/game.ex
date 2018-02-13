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
    game
    |> Enum.chunk_every(2)
    |> Enum.with_index()
    |> Enum.map(fn({throws, i}) -> {i, throws} end)
  end

  @spec score(t) :: integer
  def score(game) do
    game
    |> closed_frames()
    |> Enum.reduce(0, fn({_, throws}, acc) -> acc + sum(throws) end)
  end

  defp sum([]), do: 0
  defp sum([head | tail]), do: head + sum(tail)

  defp closed_frames(game) do
    game
    |> frames()
    |> Enum.filter(fn({frame, throws}) -> length(throws) == 2 end)
  end

  defp frame_over?({_frame, [10]}), do: true
  defp frame_over?({_frame, throws}), do: length(throws) == 2
  defp frame_over?({_frame, _throws}), do: false

  @spec frame(t) :: integer
  def frame(game) do
    game
    |> frames()
    |> Enum.filter(&frame_over?/1)
    |> length
  end
end
