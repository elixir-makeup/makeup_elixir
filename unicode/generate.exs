# Generate a file with the right character sequences
# so that `unicode_set` is not a dependency and is only
# required when one is developping `makeup_elixir`.
# The `unicode_set` library takes several minutes to
# compile, and those compile times are unacceptable
# if one only needs a bit of data that can be statically
# baked into a normal elixir file

indented =
  fn value, level ->
    text =
      value
      |> Macro.to_string()
      |> Code.format_string!()
      |> IO.iodata_to_binary()

    lines = String.split(text, "\n")
    spaces = String.duplicate(" ", level)
    indented_lines = Enum.map(lines, fn line -> [spaces, line, "\n"] end)
    IO.iodata_to_binary(indented_lines)
  end

# Identifier character categories taken directly from the Elixir spec.
variable_start_unicode_syntax =
  "[[_][:L:][:Nl:][:Other_ID_Start:]-[:Pattern_Syntax:]-[:Pattern_White_Space:]-[:Lu:]-[:Lt:]]"
variable_continue_unicode_syntax =
  "[[:ID_Start:][:Mn:][:Mc:][:Nd:][:Pc:][:Other_ID_Continue:]-[:Pattern_Syntax:]-[:Pattern_White_Space:]]"

atom_start_unicode_syntax =
  "[[_][:L:][:Nl:][:Other_ID_Start:]-[:Pattern_Syntax:]-[:Pattern_White_Space:]]"
atom_continue_unicode_syntax =
  "[[@_][:ID_Start:][:Mn:][:Mc:][:Nd:][:Pc:][:Other_ID_Continue:]-[:Pattern_Syntax:]-[:Pattern_White_Space:]]"

# TODO: Why do we need to flatten these lists? A bug in `unicode_set`?
variable_start_chars = Unicode.Set.to_utf8_char(variable_start_unicode_syntax) |> List.flatten()
variable_continue_chars = Unicode.Set.to_utf8_char(variable_continue_unicode_syntax) |> List.flatten()
variable_ending_chars = [??, ?!]

atom_start_chars = Unicode.Set.to_utf8_char(atom_start_unicode_syntax) |> List.flatten()
atom_continue_chars = Unicode.Set.to_utf8_char(atom_continue_unicode_syntax) |> List.flatten()
atom_ending_chars = [??, ?!]

indented_variable_start_chars = indented.(variable_start_chars, 4)
indented_variable_continue_chars = indented.(variable_continue_chars, 4)
indented_variable_ending_chars = indented.(variable_ending_chars, 4)

indented_atom_start_chars = indented.(atom_start_chars, 4)
indented_atom_continue_chars = indented.(atom_continue_chars, 4)
indented_atom_ending_chars = indented.(atom_ending_chars, 4)

contents = """
defmodule Makeup.Lexers.ElixirLexer.Utf8Utils do
  @moduledoc false

  # This module is generated at "dev time" so that the lexer
  # doesn't have to depend on the (excelent) `unicode_set` library,
  # which takes several minutes to compile.
  #
  # The `unicode_se` library thus becomes a `:dev` dependency of `makeup_elixir`
  # and is required only during development.

  @doc \"""
  A list of character ranges compatible with NimbleParsec
  \"""
  def variable_start_chars() do
#{indented_variable_start_chars}  end

  @doc \"""
  A list of character ranges compatible with NimbleParsec
  \"""
  def variable_continue_chars() do
#{indented_variable_continue_chars}  end

  @doc \"""
  A list of character ranges compatible with NimbleParsec
  \"""
  def variable_ending_chars() do
#{indented_variable_ending_chars}  end

  @doc \"""
  A list of character ranges compatible with NimbleParsec
  \"""
  def atom_start_chars() do
#{indented_atom_start_chars}  end

  @doc \"""
  A list of character ranges compatible with NimbleParsec
  \"""
  def atom_continue_chars() do
#{indented_atom_continue_chars}  end

  @doc \"""
  A list of character ranges compatible with NimbleParsec
  \"""
  def atom_ending_chars() do
#{indented_atom_ending_chars}  end
end
"""

filename = "lib/makeup/lexers/elixir_lexer/utf8_utils.ex"

File.write!(filename, contents)