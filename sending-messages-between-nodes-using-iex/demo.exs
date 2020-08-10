defmodule Demo do
  @doc """
    # Node One
    $ iex --sname one --cookie mysecret

    iex(one@nitro)[1]> Node.list()
    [:two@nitro]

    iex(one@nitro)[2]> send({:rev1, :two@nitro}, "remote")
    "remote"

    iex(one@nitro)[3]> send({:rev2, :two@nitro}, {self(), "again"})
    {#PID<0.116.0>, "again"}

    iex(one@nitro)[4]> flush()
    "niaga"
    :ok

    iex(one@nitro)[5]> send({:rev3, :two@nitro}, {self(), "again"})
    {#PID<0.116.0>, "again"}

    iex(one@nitro)[6]> flush()
    "niaga"
    :ok

    =====================================================================================

    # Node Two
    $ iex --sname two --cookie mysecret
    iex(two@nitro)[1]> Node.connect(:one@nitro)
    true

    iex(two@nitro)[2]> c "demo.exs"
    [Demo]

    iex(two@nitro)[3]> pid = spawn(Demo, :reverse, [])
    #PID<0.133.0>

    iex(two@nitro)[4]> send(pid, "hello")
    "hello"
    olleh

    iex(two@nitro)[5]> Process.register(pid, :rev1)
    true

    iex(two@nitro)[6]> send(:rev1, "hello")
    "hello"
    olleh

    iex(two@nitro)[7]> c "demo.exs"
    warning: redefining module Demo (current version defined in memory)
      demo.exs:1

    [Demo]

    iex(two@nitro)[8]> pid = spawn(Demo, :reverse, [])
    #PID<0.145.0>
    etomer ## when the node one send a mesage to rev1, and rev1 wouldn't sent the message back yet.

    iex(two@nitro)[9]> Process.register(pid, :rev2)
    true

    iex(two@nitro)[10]> send(:rev2, {self(), "reverse"})
    {#PID<0.116.0>, "reverse"}

    iex(two@nitro)[11]> flush()
    "esrever"
    :ok

    iex(two@nitro)[12]> c "demo.exs"
    warning: redefining module Demo (current version defined in memory)
      demo.exs:1

    [Demo]

    iex(two@nitro)[13]> pid = spawn(Demo, :reverse, [])
    #PID<0.157.0>

    iex(two@nitro)[14]> Process.register(pid, :rev3)
    true

    iex(two@nitro)[15]> send(:rev3, {self(), "reverse"})
    {#PID<0.116.0>, "reverse"}
    #PID<0.116.0>

    iex(two@nitro)[16]> flush()
    "esrever"
    :ok
    #PID<12104.116.0> ## when the node one send a mesage to rev3
  """
  def reverse do
    receive do
      # rev2
      {from_pid, msg} ->
        IO.inspect(from_pid) # rev3
        result = msg |> String.reverse()
        send(from_pid, result)
        reverse()

      # rev1
      msg ->
        result = msg |> String.reverse()
        IO.puts(result)
        reverse()
    end
  end
end
