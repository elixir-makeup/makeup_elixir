if Mix.env == :prod do
  defmodule Schism do
    defmacro schism(_, [do: {:__block__, _, beliefs}]) do
      Enum.find_value(beliefs, fn
        {:dogma, _, [_name, [do: body]]} -> body
        _ -> false
      end)
    end
  end
end
