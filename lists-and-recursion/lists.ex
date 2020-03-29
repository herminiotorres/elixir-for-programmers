defmodule Lists do
  def len([]), do: 0
  def len([_ | tail]), do: 1 + len(tail)

  def sum([]), do: 0
  def sum([head | tail]), do: head + sum(tail)

  def double([]), do: []
  def double([head | tail]), do: [ 2*head | double(tail) ]

  def square([]), do: []
  def square([head | tail]), do: [ head*head | square(tail) ]

  def sum_pairs([]), do: []
  def sum_pairs([ head1, head2 | tail ]), do: [ head1 + head2 | sum_pairs(tail) ]

  def even_length?([]), do: true
  def even_length?([_ | []]), do: false
  def even_length?([_, _ | tail]), do: even_length?(tail)

  def map([], _), do: []
  def map([head | tail], func), do: [ func.(head) | map(tail, func) ]
end

IO.puts("Lists.len([]) #=> #{Lists.len([])}")
IO.puts("Lists.len([1,2,3,4]) #=> #{Lists.len([1,2,3,4])}")

IO.puts("Lists.sum([]) #=> #{Lists.sum([])}")
IO.puts("Lists.sum([1,2,3,4]) #=> #{Lists.sum([1,2,3,4])}")

IO.puts("Lists.double([]) # =>")
Lists.double([]) |> IO.inspect

IO.puts("Lists.double([1,2,4,6]) # =>")
Lists.double([1,2,4,6]) |> IO.inspect

IO.puts("Lists.square([]) # =>")
Lists.square([]) |> IO.inspect

IO.puts("Lists.square([1,2,4,6]) # =>")
Lists.square([1,2,4,6]) |> IO.inspect

IO.puts("Lists.sum_pairs([]) # =>")
Lists.sum_pairs([]) |> IO.inspect

IO.puts("Lists.sum_pairs([1,2,3,4,5,6]) # =>")
Lists.sum_pairs([1,2,3,4,5,6]) |> IO.inspect

IO.puts("Lists.even_length?([]) # =>")
Lists.even_length?([]) |> IO.inspect

IO.puts("Lists.even_length?([1]) # =>")
Lists.even_length?([1]) |> IO.inspect

IO.puts("Lists.even_length?([1,2]) # =>")
Lists.even_length?([1,2]) |> IO.inspect

IO.puts("Lists.even_length?([1,2,3]) # =>")
Lists.even_length?([1,2,3]) |> IO.inspect

IO.puts("Lists.even_length?([1,2,3,4]) # =>")
Lists.even_length?([1,2,3,4]) |> IO.inspect

IO.puts("Lists.map([1,2,3], fn x -> 3*x end) # =>")
Lists.map([1,2,3], fn x -> 3*x end) |> IO.inspect

IO.puts("Lists.map([1,2,3], fn x -> x*x*x end) # =>")
Lists.map([1,2,3], fn x -> x*x*x end) |> IO.inspect

IO.puts("Lists.map([1,2,3], &(&1*&1*&1)) =>")
Lists.map([1,2,3], &(&1*&1*&1)) |> IO.inspect

IO.puts("length([1,2,3]) #=> #{length([1,2,3])}")

IO.puts("Enum.count([1,2,3]) #=> #{Enum.count([1,2,3])}")

IO.puts("Enum.sum([1,2,3]) #=> #{Enum.sum([1,2,3])}")

IO.puts("Enum.map([1,2,3], fn (val) -> val*2 end) # =>")
Enum.map([1,2,3], fn (val) -> val*2 end) |> IO.inspect

IO.puts("Enum.map([1,2,3], &(&1*2)) =>")
Enum.map([1,2,3], &(&1*2)) |> IO.inspect
