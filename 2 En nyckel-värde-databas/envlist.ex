defmodule EnvList do

  def test() do
    list = [{:a, 1}, {:b, 2}, {:c, 4}]
    add(list, :d, 10)
    remove(list, :d)
  end

  # Create new empty list
  def new() do
    []
  end

  # Addition
  def add([], key, value) do
    [{key, value}]
  end
  def add([{key, _} | tail], key, value) do
    [{key, value} | tail]
  end
  def add([head | tail], key, value) do
    [head | add(tail, key, value)]
  end

  # Lookup key
  def lookup([], _) do
    nil
  end
  def lookup([{key, value} | _], key) do
    {key, value}
  end
  def lookup([_ | tail], key) do
    lookup(tail, key)
  end

  # Remove from list
  def remove([], _) do
    []
  end

  def remove([{key, value} | tail], key) do
    tail
  end

  def remove([head | tail], key) do
    [head | remove(tail, key)]
  end


end
