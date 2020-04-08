# Process

## Spawning a New Process

Spawns the given function __fun__ from the given __module__ passing it the given __args__
and returns its PID.

Typically developers do not use the __spawn__ functions, instead they use
abstractions such as __Task__, __GenServer__ and __Agent__, built on top of __spawn__, that
spawns processes with more conveniences in terms of introspection and
debugging.

```shell
$ iex 01_procs.exs
iex> spawn(Procs, :greeter, ["World"])
#PID<0.124.0>
Hello world
```

How do we know it even started them? Elixir can use the Erlang __*observer*__, which can show all sorts of useful information. Create a new observer window in iex using

```shell
iex> :observer.start()
```

By default, the observer updates every 5 seconds. Let’s drop that down to one second by clicking on the `View` option in the menu bar, selecting `Refresh interval` and moving the slider down to 1.

Now try with 100,000 processes. 

```shell
iex> Enum.each(1..100000, fn _ -> spawn(fn -> Process.sleep(5000) end) end)
:ok
```

## Sending and Receiving messages

The `send` function sends a message to a process, `receive` waits for a message to arrive, binds it to a variable, then executes the associated code. Messages sent to nonexistent processes are quietly thrown away. Use recursion to implement a receiver loop in your process.

```shell
$ iex 02_procs.exs
iex> pid = spawn(Procs, :greeter, [])
#PID<0.124.0>
iex> send(pid, "World")
"World"
Hello "World"
iex> pid = spawn Procs, :greetings, ["Hello"]
#PID<0.146.0>
iex> send(pid, "World")
"World"
Hello: World
```

## Pattern Matching Messages

You maintain state in your process by passing it as a parameter in the recursive call. You can update this state when handling a message. You can use pattern matching in the body of a `receive`. The general syntax is:

```elixir
receive do
  pattern_1 ->
    code_1
  
  pattern_2 ->
    code_2
  
      :  :
    
  pattern_n ->
    code_n
end
```

The incoming message is matched against each pattern in turn. When one matches, the corresponding code is run, and the receive is complete, `receive` waits for a message to arrive, binds it to a variable, then executes the associated code. Messages sent to nonexistent processes are quietly thrown away. Use recursion to implement a receiver loop in your process.

```shell
$ iex 03_procs.exs
iex> pid = spawn(Procs, :greeter, [0])
#PID<0.156.0>
iex> send(pid, "world")
0: Hello "world"
"world"
iex> send(pid, "world")
"world"
0: Hello "world"
iex> send(pid, {:add, 99})
{:add, 99}
iex> send(pid, "world")   
"world"
99: Hello "world"
iex> send(pid, {:add, -4})
{:add, -4}
iex> send(pid, "world")   
"world"
95: Hello "world"
iex> pid = spawn(Procs, :greeter, [2])
#PID<0.174.0>
iex> send(pid, "world")              
"world"
2: Hello "world"
iex> send(pid, {:reset})             
{:reset}
iex> send(pid, "world") 
"world"
0: Hello "world"

```

Use recursion to implement a receiver loop in your process.

## Linking Our Fate to Our Children's Fate

The `spawn` creates an isolated process—it is independent of the process that created it. You don’t (by default) receive any notification that it has died. The `spawn_link` links the creating and created processes. If one dies an abnormal death, the other is killed. Most of the time, this is the behavior we want. Without it, we’ll leave zombies lying around, an we won’t know that subprocesses have died.

```shell
$ iex 04_procs.exs
iex> pid = spawn(Procs, :greeter, [0])
#PID<0.188.0>
iex> send(pid, "Hello")
"Hello"
0: Hello "Hello"
iex> send(pid, {:boom, :bad})
{:boom, :bad}
iex> send(pid, "Hello")               
"Hello"
iex> pid = spawn_link(Procs, :greeter, [0])
#PID<0.193.0>
iex> send(pid, "Hello")                    
"Hello"
0: Hello "Hello"
iex> send(pid, {:boom, :bad})              
{:boom, :bad}

▶▶▶
** (EXIT from #PID<0.114.0>) shell process exited with reason: :bad

Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
iex> pid = spawn_link(Procs, :greeter, [0])
#PID<0.116.0>
iex> send(pid, "Hello")
0: Hello "Hello"
"Hello"
iex> send(pid, {:boom, :normal})           
{:boom, :normal}
```

## Agents—Simple State Holders

Agents are an abstraction that keep state in a separate `process.Class`. The `Agent.get(pid, func)` runs the function in the agent, passing it the state. The value returned by the function is the value returned by `get`. The `Agent.update(pid, func)` runs the function in the agent, passing it the state. The value returned by the function becomes the new state. The `Agent.get_and_update(pid, func)` runs the function with the state. The function should return a two-element tuple containing the return value to be passed to the caller and the updated state.

```shell
iex> {:ok, pid} = Agent.start_link(fn -> 0 end)
{:ok, #PID<0.952.0>}
iex> Agent.get(pid, fn count -> count end) 
0
iex> Agent.update(pid, fn count -> count+1 end)
:ok
iex> Agent.get(pid, fn count -> count end) 
1
iex> Agent.get_and_update(pid, fn state -> {state, state+1} end)
1
iex> Agent.get_and_update(pid, fn state -> {state, state+1} end)
2
iex> Agent.get_and_update(pid, fn state -> {state, state+1} end)
3
iex> Agent.get_and_update(pid, fn state -> {state, state+1} end)
4

```

## Runs a Fibonacci with Cache using Agent

```shell
$ iex
iex> c "fibonacci_cached.exs"
[FibonacciCached]
iex> c "fibonacci.exs"       
[Fibonacci]
iex> {:ok, agent} = Fibonacci.start()
{:ok, #PID<0.125.0>}
iex> Fibonacci.calculate(agent, 10)
55
iex> Fibonacci.print(agent)        
%{
  0 => 0,
  1 => 1,
  2 => 1,
  3 => 2,
  4 => 3,
  5 => 5,
  6 => 8,
  7 => 13,
  8 => 21,
  9 => 34,
  10 => 55
}
```



## References

- [Hey Process, there is a Message for you!](https://www.poeticoding.com/hey-process-there-is-a-message-for-you/)

- [Spawning processes in Elixir, a gentle introduction to concurrency](https://www.poeticoding.com/spawning-processes-in-elixir-a-gentle-introduction-to-concurrency/)

- [The Primitives of Elixir Concurrency: a Full Example](https://www.poeticoding.com/the-primitives-of-elixir-concurrency-full-example/)

- [Demystifying processes in Elixir](https://blog.appsignal.com/2017/05/18/elixir-alchemy-demystifying-processes-in-elixir.html)

- [Elixir Getting Started - Processes](https://elixir-lang.org/getting-started/processes.html)

- [Elixir Doc - Process](https://hexdocs.pm/elixir/Process.html)

- [Elixir Getting Started - Agent](https://elixir-lang.org/getting-started/mix-otp/agent.html)

- [Elixir Doc - Agent](https://hexdocs.pm/elixir/Agent.html)

- [Intro to Agents - ElixirCasts.io](https://elixircasts.io/intro-to-agents)

  

