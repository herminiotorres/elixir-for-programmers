defmodule Procs do
  def greeter(name) do
    Process.sleep(1000)
    IO.puts("Hello #{name}")
  end
end
