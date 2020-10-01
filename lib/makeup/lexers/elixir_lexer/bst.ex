defmodule Makeup.Lexers.ElixirLexer.BST do
  def insert_integer(bst, n) do
    case bst do
      nil ->
        {n, nil, nil}
      
      {root, lhs, rhs} when is_integer(n) ->
        cond do
          n < root ->
            {root, insert(lhs, n), rhs}

          n > root ->
            {root, lhs, insert(rhs, n)}

          true ->
            bst
        end
      
      {root = {first, last}, lhs, rhs} ->
        cond do
          n < first ->
            {root, insert(lhs, n), rhs}

          n > last ->
            {root, lhs, insert(rhs, n)}

          n == root ->
            bst
        end
    end
  end

  def insert_range(bst, range = {a, b}) do
    case bst do
      nil ->
        {range, nil, nil}

      {root, lhs, rhs} when is_integer(root) ->
        cond do
          b < root ->
            {root, insert(lhs, range), rhs}

          a > root ->
            {root, lhs, insert(rhs, range)}

          true ->
            bst
        end

      {root = {first, last}, lhs, rhs} ->
        cond do
          b < first ->
            {root, insert(lhs, range), rhs}

          a > last ->
            {root, lhs, insert(rhs, range)}

          true ->
            bst
        end
    end
  end

  def insert(bst, range = {_a, _b}), do: insert_range(bst, range)
  def insert(bst, n) when is_integer(n), do: insert_integer(bst, n)

  defp convert_if_range(%Range{} = range), do: {range.first, range.last}
  defp convert_if_range(other), do: other

  def convert_ranges(list), do: Enum.map(list, &convert_if_range/1)

  def create(list) do
    converted_list = convert_ranges(list) |> Enum.shuffle()
    Enum.reduce(converted_list, nil, fn x, bst ->
      insert(bst, x)
    end)
  end

  def find(bst, n) do
    case bst do
      nil ->
        false
      
      {{first, _last}, lhs, _rhs} when n < first ->
        find(lhs, n)

      {{_first, last}, _lhs, rhs} when n > last ->
        find(rhs, n)

      {{first, last}, _lhs, _rhs} when n >= first and n <= last ->
        true

      {x, lhs, _rhs} when is_integer(x) and n < x ->
        find(lhs, n)

      {x, _lhs, rhs} when is_integer(x) and n > x ->
        find(rhs, n)

      {x, _lhs, _rhs} when is_integer(x) and n == x ->
        true
    end
  end
end