defmodule Chain do
  @doc """
    # one@nitro

    iex --sname one --cookie :mysecret chain.exs

    iex(one@nitro)[1]> Chain.start_link(:two@nitro)
    true
    iex(one@nitro)[2]> send(:chainer, {:trigger, []})
    []
    {:trigger, []}
    [:four@nitro, :three@nitro, :two@nitro, :one@nitro]
    [:four@nitro, :three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro,
     :two@nitro, :one@nitro]
    [:four@nitro, :three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro,
     :two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro]
    done

    =================================================================================

    # two@nitro

    iex --sname two --cookie :mysecret chain.exs

    iex(two@nitro)[1]> Chain.start_link(:three@nitro)
    true
    [:one@nitro]
    [:one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro]
    [:one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro, :four@nitro,
     :three@nitro, :two@nitro, :one@nitro]
    [:one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro, :four@nitro,
     :three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro,
     :one@nitro]
    done

    =================================================================================

    # three@nitro

    iex --sname three --cookie :mysecret chain.exs

    iex(three@nitro)[1]> Chain.start_link(:four@nitro)
    true
    [:two@nitro, :one@nitro]
    [:two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro]
    [:two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro,
     :four@nitro, :three@nitro, :two@nitro, :one@nitro]
    [:two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro,
     :four@nitro, :three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro,
     :two@nitro, :one@nitro]
    done

    =================================================================================

    # four@nitro

    iex --sname four --cookie :mysecret chain.exs

    iex(four@nitro)[1]> Chain.start_link(:one@nitro)
    true
    [:three@nitro, :two@nitro, :one@nitro]
    [:three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro,
     :one@nitro]
    [:three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro,
     :one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro]
    [:three@nitro, :two@nitro, :one@nitro, :four@nitro, :three@nitro, :two@nitro,
     :one@nitro, :four@nitro, :three@nitro, :two@nitro, :one@nitro, :four@nitro,
     :three@nitro, :two@nitro, :one@nitro]
    done
  """

  defstruct(
    next_node: nil,
    count: 1000 #4
  )

  def start_link(next_node) do
    # grab the pid process and pipe to a register doing a name
    spawn_link(__MODULE__, :message_loop, [%__MODULE__{next_node: next_node}])
    |> Process.register(:chainer)
  end

  def message_loop(%{count: 0}) do
    IO.puts "done"
  end

  def message_loop(state) do
    receive do
      {:trigger, list} ->
        IO.inspect(list)
        # :timer.sleep 500
        # send({:chainer, state.next_node}, {:trigger, [node() | list]})
        send({:chainer, state.next_node}, {:trigger, []})
    end

    message_loop(%{state | count: state.count - 1})
  end
end
