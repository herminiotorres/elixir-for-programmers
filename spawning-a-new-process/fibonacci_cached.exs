defmodule FibonacciCached do
  def start() do
    Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
  end

  def get(agent, key) do
    state = Agent.get(agent, fn state -> state end)
    Map.get(state, key)
  end

  def add(agent, key, value) do
    Agent.update(agent, fn state -> Map.put(state, key, value) end)
  end

  def print(agent) do
    Agent.get(agent, fn state -> state end)
  end
end
