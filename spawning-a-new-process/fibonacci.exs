defmodule Fibonacci do
  def start() do
    FibonacciCached.start()
  end

  def print(agent) do
    FibonacciCached.print(agent)
  end

  def calculate(_agent, 0), do: 0
  def calculate(_agent, 1), do: 1

  def calculate(agent, key) do
    case FibonacciCached.get(agent, key) do
      nil ->
        value = calculate(agent, key-1) + calculate(agent, key-2)
        FibonacciCached.add(agent, key, value)
        value
      cached_value ->
        cached_value
    end
  end
end
