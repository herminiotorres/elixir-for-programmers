defmodule Procs do
  def greeter() do
    receive do
      message ->
        IO.puts("Hello #{inspect(message)}")
    end
    greeter()
  end

  def greetings(what_to_say) do
    receive do
      message ->
        IO.puts("#{what_to_say}: #{message}")
    end
  end
end
