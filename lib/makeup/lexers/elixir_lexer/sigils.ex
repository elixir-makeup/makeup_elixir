defmodule Makeup.Lexers.ElixirLexer.Sigils do
  @moduledoc false
  import Schism

  schism "sigils" do
    dogma "external" do
      # This module is generated at "dev time" so that the lexer
      # doesn't have to depend on the (excelent) `unicode_set` library,
      # which takes several minutes to compile.
      import NimbleParsec
      import Makeup.Lexers.ElixirLexer.Helper

      # Crazy recursive mutual dependencies
      iex_prompt_inside_string = parsec({Makeup.Lexers.ElixirLexer, :iex_prompt_inside_string})

      combinators_inside_string = [
        parsec({Makeup.Lexers.ElixirLexer, :combinators_inside_string})
      ]

      sigil_delimiters = [
        {~S["""], ~S["""]},
        {"'''", "'''"},
        {"\"", "\""},
        {"'", "'"},
        {"/", "/"},
        {"{", "}"},
        {"[", "]"},
        {"(", ")"}
      ]

      # These are the "generic" sigils, that is, those that are not defined by default.
      # For example, `~c` is not a "normal" sigil because be default it represents a charlist
      # and is highlighted as such.
      normal_sigil_interpol_range = [?a..?z, not: ?c, not: ?d, not: ?n, not: ?r, not: ?s]
      normal_sigil_no_interpol_range = [?A..?Z, not: ?c, not: ?D, not: ?N, not: ?R, not: ?S]

      sigils_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(
            ldelim,
            rdelim,
            normal_sigil_interpol_range,
            combinators_inside_string,
            :string_sigil
          )
        end

      sigils_no_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(
            ldelim,
            rdelim,
            normal_sigil_no_interpol_range,
            [escape_delim(rdelim), iex_prompt_inside_string],
            :string_sigil
          )
        end

      sigils_string_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(ldelim, rdelim, [?s, ?c], combinators_inside_string, :string)
        end

      sigils_string_no_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(
            ldelim,
            rdelim,
            [?S, ?C],
            [escape_delim(rdelim), iex_prompt_inside_string],
            :string
          )
        end

      sigils_regex_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(ldelim, rdelim, [?r], combinators_inside_string, :string_regex)
        end

      sigils_regex_no_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(
            ldelim,
            rdelim,
            [?R],
            [escape_delim(rdelim), iex_prompt_inside_string],
            :string_regex
          )
        end

      # Calendar types
      sigils_calendar_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(ldelim, rdelim, [?d, ?n, ?t, ?u], combinators_inside_string, :literal_date)
        end

      sigils_calendar_no_interpol =
        for {ldelim, rdelim} <- sigil_delimiters do
          sigil(
            ldelim,
            rdelim,
            [?D, ?N, ?T, ?U],
            [escape_delim(rdelim), iex_prompt_inside_string],
            :literal_date
          )
        end

      all_sigils =
        sigils_interpol ++
          sigils_no_interpol ++
          sigils_string_interpol ++
          sigils_string_no_interpol ++
          sigils_regex_interpol ++
          sigils_regex_no_interpol ++
          sigils_calendar_interpol ++
          sigils_calendar_no_interpol

      defcombinator(:all_sigils, choice(all_sigils))
    end

    heresy "internal" do
      # this module does not exist
    end
  end
end
