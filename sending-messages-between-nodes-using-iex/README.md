# Sending Messages Between Nodes Using IEx

## Remote Nodes

So far we’ve only run nodes on a single computer. If you have access to two or more machines, try running the nodes on them, sending messages between the boxes.

First, find the IP address of the network interface on both boxes. Then make sure they are on the same subnet by confirming you can ping one from the other.

Second, if you’re running a firewall, either stop it temporarily or whitelist traffic so that you machines can talk freely.

When you start IEx, you’ll use the `--name` option, and include the IP address of the machine hosting the node. However, that’s not enough.

Elixir/Erlang implement a trivial shared secret mechanism. To connect, nodes must all agree on the value of a cookie. This is specified on the command line:

So, if one of your machines has an IP address of 192.168.1.12, you could use:

```shell
$ iex --name one@192.168.1.12 --cookie dough
```

On another machine, with a different IP address, you could use:

```shell
$ iex --name two@192.168.1.67 --cookie dough
```

Then one could connect to the other using:

```shell
iex> Node.connect :"two@192.168.1.67"
```

Use this to get `demo.exs` working across a network.

### Why No Local Cookies?

We didn’t specify cookies when running local nodes. But that doesn’t mean they don’t exist.

If you don’t use a `--cookie` option on the command line, the runtime looks for a file `.erlang.cookie` in your home. If it finds one, it uses the content as the cookie value. If it doesn’t, it creates it and sticks a random string in it.

This way, our local nodes were using a cookie—they just didn’t need us to specify it explicitly.

## Security—None

Please remember this: __*NEVER CONNECT ELIXIR NODES OVER UNENCRYPTED PUBLIC CONNECTIONS.*__

The traffic between Elixir nodes, including the initial cookie negotiation, is effectively sent in the clear. Anyone can snoop on it, and it is easy to perform things such as man-in-the-middle attacks.

If you want to distribute nodes across the internet, tunnel the traffic through an SSH connection or over a VPN.

## Example

### `IEx` one:

```shell
$ iex --sname one --cookie abc
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(one@nitro)> c "demo.exs"
[Demo]
iex(one@nitro)> pid = spawn(Demo, :reverse, [])
#PID<0.127.0>
iex(one@nitro)> Process.register(pid, :demo_reverse)
true
iex(one@nitro)> send(:demo_reverse, {self(), "hello world"})
#PID<0.115.0>
{#PID<0.115.0>, "hello world"}
iex(one@nitro)> flush()
"dlrow olleh"
:ok
iex(one@nitro)>
#PID<16239.115.0> 
```

### `IEx` two:

```shell
$ iex --sname two --cookie abc
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(two@nitro)> send({:demo_reverse, :one@nitro}, {self(), "again"})
{#PID<0.115.0>, "again"}
iex(two@nitro)[2]> flush()
"niaga"
:ok
```

