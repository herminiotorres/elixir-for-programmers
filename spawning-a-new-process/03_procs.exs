defmodule Procs do
  def greeter(count) do
    receive do
      {:add, number} ->
        greeter(count + number)
      {:reset} ->
        greeter(0)
      message ->
        IO.puts("#{count}: Hello #{inspect(message)}")
        greeter(count)
    end
  end
end
