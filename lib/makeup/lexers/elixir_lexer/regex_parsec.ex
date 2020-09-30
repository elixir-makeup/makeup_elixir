defmodule Makeup.Lexers.ElixirLexer.RegexParsec do
  import NimbleParsec

  defmacro defregexparsec(name, re) do
    {evaluated_re, _} = Code.eval_quoted(re)
    anchored_re = Regex.compile!("^" <> evaluated_re.source, evaluated_re.opts)
    escaped_re = Macro.escape(anchored_re)
    name__0 = String.to_atom(Atom.to_string(name) <> "__0")

    quote do
      def unquote(name)(input) do
        unquote(name__0)(input, [], [], %{}, {1, 0}, 0)
      end

      def unquote(name__0)(input, acc, stack, context, line_offset, column) do
        case Regex.run(unquote(escaped_re), input) do
          [bin | _] ->
            length = byte_size(bin)
            # Split the string in two parts; keep the second part
            <<_part::binary-size(length), rest::binary>> = input
            # ----------------------------------------------------------------
            # For efficincy reason ignore line numbers; we won't be using them
            # -----------------------------------------------------------------
            # # How many lines have we advanced?
            # lines = String.split("\n")
            # delta_lines = length(lines)
            # # The column is the byte offset of the last line (I think?)
            # new_column =
            #   case lines do
            #     [] -> 0
            #     _ -> lines |> List.last() |> byte_size()
            #   end

            # I hope I'm returning the right format?
            {:ok, [bin | acc], rest, context, line_offset, column + length}

          nil ->
            {:error, unquote("expected to match regex #{inspect(evaluated_re)}"), input, context,
             line_offset, column}
        end
      end
    end
  end
end