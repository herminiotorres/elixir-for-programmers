defmodule NamedFibonacci do
  def start() do
    NamedFibonacciCached.start()
  end

  def print() do
    NamedFibonacciCached.print()
  end

  def calculate(0), do: 0
  def calculate(1), do: 1

  def calculate(key) do
    case NamedFibonacciCached.get(key) do
      nil ->
        value = calculate(key-1) + calculate(key-2)
        NamedFibonacciCached.add(key, value)
        value
      cached_value ->
        cached_value
    end
  end
end
