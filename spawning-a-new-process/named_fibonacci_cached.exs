defmodule NamedFibonacciCached do
  @me __MODULE__

  def start() do
    Agent.start_link(fn -> %{0 => 0, 1 => 1} end, name: @me)
  end

  def get(key) do
    state = Agent.get(@me, fn state -> state end)
    Map.get(state, key)
  end

  def add(key, value) do
    Agent.update(@me, fn state -> Map.put(state, key, value) end)
  end

  def print() do
    Agent.get(@me, fn state -> state end)
  end
end
