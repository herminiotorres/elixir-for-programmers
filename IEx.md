# IEx

When you would like to finish/stop your IEx, you could using `CTRL+C` twice, and you get this same message:
```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:22 :: 1] > 
BREAK: (a)bort (c)ontinue (p)roc info (i)nfo (l)oaded
       (v)ersion (k)ill (D)b-tables (d)istribution

```

Another option for finish/stop your IEx is calling the `System.halt()`.

When you would like clear the IEx, you could call the `clear()` function, like this:
```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:26 :: 1] > 123
123
iex [11:26 :: 2] > 456
456
iex [11:26 :: 3] > 789
789
iex [11:26 :: 4] > clear()

```

After call the function:
```elixir
iex [11:26 :: 5] >
```

When you would like to getting on in your IEx historical, you should try using a `v` shortcut, look like this:
```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:21 :: 1] > 123
123
iex [11:21 :: 2] > 456
456
iex [11:21 :: 3] > 789
789
iex [11:21 :: 4] > v 1
123
iex [11:21 :: 5] > v 2
456
iex [11:21 :: 6] > v 3
789
```

When you would like to know more about your data, you should using the `i` shortcut, something like this:
```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:30 :: 1] > i [%{key: 'value'}]
Term
  [%{key: 'value'}]
Data type
  List
Reference modules
  List
Implemented protocols
  Collectable, Enumerable, IEx.Info, Inspect, List.Chars, String.Chars

```

When you have some doubts about something, you can you `h` shortcut, something like this:
```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:35 :: 1] > h String

String                                     

Strings in Elixir are UTF-8 encoded binaries.

Strings in Elixir are a sequence of Unicode characters, typically written
between double quoted strings, such as "hello" and "héllò".

In case a string must have a double-quote in itself, the double quotes must be
escaped with a backslash, for example: "this is a string with \"double
quotes\"".

You can concatenate two strings with the <>/2 operator:

  iex> "hello" <> " " <> "world"
  "hello world"

```

The IEx as the auto-complete, so you can using a `<TAB>` in your keyboard for complete what you need some help, we use `<TAB>`, 
for complete our sentence when you try to write `String`, and after we using for complete try to found the functions on `String`.
You can see something like this:

```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:37 :: 1] > h String
String      StringIO    
iex [11:37 :: 1] > h String.
Break                   Casing                  Chars                   
Tokenizer               Unicode                 at/2                    
bag_distance/2          capitalize/1            capitalize/2            
chunk/2                 codepoints/1            contains?/2             
downcase/1              downcase/2              duplicate/2             
ends_with?/2            equivalent?/2           first/1                 
graphemes/1             jaro_distance/2         last/1                  
length/1                match?/2                myers_difference/2      
next_codepoint/1        next_grapheme/1         next_grapheme_size/1    
pad_leading/2           pad_leading/3           pad_trailing/2          
pad_trailing/3          printable?/1            printable?/2            
replace/3               replace/4               replace_leading/3       
replace_prefix/3        replace_suffix/3        replace_trailing/3      
reverse/1               slice/2                 slice/3                 
split/1                 split/2                 split/3                 
split_at/2              splitter/2              splitter/3              
starts_with?/2          to_atom/1               to_charlist/1           
to_existing_atom/1      to_float/1              to_integer/1            
to_integer/2            trim/1                  trim/2                  
trim_leading/1          trim_leading/2          trim_trailing/1         
trim_trailing/2         upcase/1                upcase/2                
valid?/1                
iex [11:37 :: 1] > h String.upcase

	def upcase(string, mode \\ :default)                      
-----------------------------------------------------------------------------
  @spec upcase(t(), :default | :ascii | :greek) :: t()

Converts all characters in the given string to uppercase according to mode.

mode may be :default, :ascii or :greek. The :default mode considers all
non-conditional transformations outlined in the Unicode standard. :ascii
uppercases only the letters a to z. :greek includes the context sensitive
mappings found in Greek.

## Examples

  iex> String.upcase("abcd")
  "ABCD"

  iex> String.upcase("ab 123 xpto")
  "AB 123 XPTO"

  iex> String.upcase("olá")
  "OLÁ"

The :ascii mode ignores Unicode characters and provides a more performant
implementation when you know the string contains only ASCII characters:

  iex> String.upcase("olá", :ascii)
  "OLá"
```

When you try write something in your IEx and going wrong, you can use `#iex:break` for breaking and you could start writing again. Look like this:
```elixir
$ iex
Erlang/OTP 22 [erts-10.6.4] [source] [64-bit] [smp:12:12] [ds:12:12:10] [async-threads:1] [hipe]

Interactive Elixir (1.10.1) - press Ctrl+C to exit (type h() ENTER for help)
iex [11:49 :: 1] > my_string = "something 
... [11:49 :: 1] > wrong
... [11:49 :: 1] > on
... [11:49 :: 1] > my
... [11:49 :: 1] > string
... [11:49 :: 1] > who I can breaking this?
... [11:49 :: 1] > #iex:break

▶▶▶
** (TokenMissingError) iex:1: incomplete expression
```
