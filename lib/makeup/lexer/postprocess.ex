defmodule Makeup.Lexer.Postprocess do
  @doc """
  TODO
  """
  def invert_word_map(pairs) do
    nested =
      for {ttype, words} <- pairs do
        for word <- words, do: {word, ttype}
      end

    nested
    |> List.flatten
    |> Enum.into(%{})
  end
end