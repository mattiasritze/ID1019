defmodule LOL do


  def test do
      File.stream!("inputs/inputs.txt")
      |> Stream.map(&String.trim/1)
      |> Stream.chunk_while(0,
      fn x, acc ->
        case x do
          "" -> {:cont, acc, 0}
          _ -> {:cont, acc+ String.to_integer(x)}
        end
      end,
      fn _ -> {:cont, []} end)
      |> Enum.to_list()
  end
end
