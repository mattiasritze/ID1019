defmodule Calorie do

  def calc do
    list = File.read!("inputs/inputs.txt")
    |> String.split("\n")
    |> Enum.chunk_while(0,
    fn
      "", chunk ->
        {:cont, chunk, 0}
      value, chunk ->
        {:cont, String.to_integer(value) + chunk}
    end,
    fn chunk -> {:cont, chunk, 0} end
  )

    |> Enum.reject(&(&1) == 0)
    |> Enum.sort(:desc)

    #Top 3
    top3 = list |> Enum.take(3) |> Enum.sum()

    #Top 1
    top1 = list |> List.first()
    {top1, top3}

  end
end
