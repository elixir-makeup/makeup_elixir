defmodule Makeup.Lexer.Combinators do
  import NimbleParsec

  @doc """
  Wraps the given combinator into a token of the given `ttype`.

  Instead of a combinator, the first argument can also be a string literal.
  """
  def token(literal, token_type) when is_binary(literal) do
    replace(string(literal), {token_type, %{}, literal})
  end

  def token(combinator, token_type) do
    map(combinator, {Makeup.Lexer.Combinators, :__token__, [token_type]})
  end

  def token(literal, token_type, attrs) when is_binary(literal) do
    replace(string(literal), {token_type, attrs, literal})
  end

  def token(combinator, token_type, attrs) do
    map(combinator, {Makeup.Lexer.Combinators, :__token__, [token_type, attrs]})
  end

  @doc """
  Joins the result of the given combinator into a single string.
  """
  def lexeme(combinator) do
    reduce(combinator, {Makeup.Lexer.Combinators, :__lexeme__, []})
  end

  @doc false
  def __token__(text, token_type) do
    {token_type, %{}, text}
  end

  @doc false
  def __token__(text, token_type, attrs) do
    {token_type, text, attrs}
  end

  @doc false
  def __lexeme__(acc) do
    acc |> :lists.flatten |> Enum.join
  end

  @doc """
  Matches one of the literal strings in the list.
  """
  def word_from_list(words) do
    choice(for word <- words, do: string(word))
  end

  @doc """
  Matches one of the literal strings in the list and wraps it in a token of the given type.
  """
  def word_from_list(words, ttype) do
    choice(for word <- words, do: token(word, ttype))
  end

  @doc """
  Matches one of the literal strings in the list and wraps it in a token of the given `type`, with the given `attrs`.
  """
  def word_from_list(words, ttype, attrs) do
    choice(for word <- words, do: token(word, ttype, attrs))
  end

  @doc """
  Matches a given combinator, repeated 0 or more times, surrounded by left and right delimiters.

  Delimiters can be combinators or literal strings (wither both combinators or both literal strings)
  """
  def many_surrounded_by(combinator, left, right) when is_binary(left) and is_binary(right) do
    token(left, :punctuation)
    |> concat(
        repeat_until(
          combinator,
          [string(right)]))
    |> concat(token(right, :punctuation))
  end

  def many_surrounded_by(combinator, left, right) do
    left
    |> concat(
        repeat_until(
          combinator,
          [right]))
    |> concat(right)
  end

  @doc """
  Matches a given combinator, repeated 0 or more times, surrounded by left and right delimiters,
  and wraps the `right` and `left` delimiters into a token of the given `ttype`.
  """
  def many_surrounded_by(combinator, left, right, ttype) do
    token(left, ttype)
    |> concat(
        repeat_until(
          combinator,
          [string(right)]))
    |> concat(token(right, ttype))
  end
end



