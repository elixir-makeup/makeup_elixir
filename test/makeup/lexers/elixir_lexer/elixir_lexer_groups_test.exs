defmodule Makeup.Lexers.ElixirLexer.ElixirLexerGroupsTest do
  # The tests need to be checked manually!!! (remove this line when they've been checked)
  use ExUnit.Case, async: true
  alias Makeup.Lexers.ElixirLexer
  alias Makeup.Lexer.Postprocess

  # This function has two purposes:
  # 1. Ensure deterministic lexer output (no random prefix)
  # 2. Convert the token values into binaries so that the output
  #    is more obvious on visual inspection
  #    (iolists are hard to parse by a human)
  def lex(text) do
    text
    |> ElixirLexer.lex(group_prefix: "group")
    |> Postprocess.token_values_to_binaries()
    |> Enum.map(fn {ttype, meta, value} -> {ttype, Map.delete(meta, :language), value} end)
  end

  describe "all group transitions" do

    test "`do ... end` + `do ... end`" do
      assert lex("do do x end end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `do ... else ... end`" do
      assert lex("do do x else x end end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `fn ... end`" do
      assert lex("do fn -> x end end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `(...)`" do
      assert lex("do (x) end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `[...]`" do
      assert lex("do [x] end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `{...}`" do
      assert lex("do {x} end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `%{...}`" do
      assert lex("do %{x} end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `%Struct{...}`" do
      assert lex("do %Struct{x} end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `#OpaqueStruct<...>`" do
      assert lex("do #OpaqueStruct< x > end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... end` + `<<...>>`" do
      assert lex("do << x >> end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `do ... end`" do
      assert lex("do do x end else do x end end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `do ... else ... end`" do
      assert lex("do do x else x end else do x else x end end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `fn ... end`" do
      assert lex("do fn -> x end else fn -> x end end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-3"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `(...)`" do
      assert lex("do (x) else (x) end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-3"}, ")"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `[...]`" do
      assert lex("do [x] else [x] end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-3"}, "]"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `{...}`" do
      assert lex("do {x} else {x} end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-3"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `%{...}`" do
      assert lex("do %{x} else %{x} end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-3"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `%Struct{...}`" do
      assert lex("do %Struct{x} else %Struct{x} end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "%"},
        {:name_class, %{group_id: "group-3"}, "Struct"},
        {:punctuation, %{group_id: "group-3"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-3"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `#OpaqueStruct<...>`" do
      assert lex("do #OpaqueStruct< x > else #OpaqueStruct< x > end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "#"},
        {:name_class, %{group_id: "group-3"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-3"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, ">"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `<<...>>`" do
      assert lex("do << x >> else << x >> end") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `do ... end`" do
      assert lex("fn -> do x end end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `do ... else ... end`" do
      assert lex("fn -> do x else x end end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `fn ... end`" do
      assert lex("fn -> fn -> x end end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `(...)`" do
      assert lex("fn -> (x) end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `[...]`" do
      assert lex("fn -> [x] end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `{...}`" do
      assert lex("fn -> {x} end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `%{...}`" do
      assert lex("fn -> %{x} end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `%Struct{...}`" do
      assert lex("fn -> %Struct{x} end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `#OpaqueStruct<...>`" do
      assert lex("fn -> #OpaqueStruct< x > end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `<<...>>`" do
      assert lex("fn -> << x >> end") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`(...)` + `do ... end`" do
      assert lex("(do x end)") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `do ... else ... end`" do
      assert lex("(do x else x end)") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `fn ... end`" do
      assert lex("(fn -> x end)") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `(...)`" do
      assert lex("((x))") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `[...]`" do
      assert lex("([x])") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `{...}`" do
      assert lex("({x})") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `%{...}`" do
      assert lex("(%{x})") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `%Struct{...}`" do
      assert lex("(%Struct{x})") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `#OpaqueStruct<...>`" do
      assert lex("(#OpaqueStruct< x >)") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `<<...>>`" do
      assert lex("(<< x >>)") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`[...]` + `do ... end`" do
      assert lex("[do x end]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `do ... else ... end`" do
      assert lex("[do x else x end]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `fn ... end`" do
      assert lex("[fn -> x end]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `(...)`" do
      assert lex("[(x)]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `[...]`" do
      assert lex("[[x]]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `{...}`" do
      assert lex("[{x}]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `%{...}`" do
      assert lex("[%{x}]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `%Struct{...}`" do
      assert lex("[%Struct{x}]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `#OpaqueStruct<...>`" do
      assert lex("[#OpaqueStruct< x >]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `<<...>>`" do
      assert lex("[<< x >>]") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`{...}` + `do ... end`" do
      assert lex("{do x end}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `do ... else ... end`" do
      assert lex("{do x else x end}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `fn ... end`" do
      assert lex("{fn -> x end}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `(...)`" do
      assert lex("{(x)}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `[...]`" do
      assert lex("{[x]}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `{...}`" do
      assert lex("{{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `%{...}`" do
      assert lex("{%{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `%Struct{...}`" do
      assert lex("{%Struct{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `#OpaqueStruct<...>`" do
      assert lex("{#OpaqueStruct< x >}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `<<...>>`" do
      assert lex("{<< x >>}") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `do ... end`" do
      assert lex("%{do x end}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `do ... else ... end`" do
      assert lex("%{do x else x end}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `fn ... end`" do
      assert lex("%{fn -> x end}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `(...)`" do
      assert lex("%{(x)}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `[...]`" do
      assert lex("%{[x]}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `{...}`" do
      assert lex("%{{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `%{...}`" do
      assert lex("%{%{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `%Struct{...}`" do
      assert lex("%{%Struct{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `#OpaqueStruct<...>`" do
      assert lex("%{#OpaqueStruct< x >}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `<<...>>`" do
      assert lex("%{<< x >>}") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `do ... end`" do
      assert lex("%Struct{do x end}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `do ... else ... end`" do
      assert lex("%Struct{do x else x end}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `fn ... end`" do
      assert lex("%Struct{fn -> x end}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `(...)`" do
      assert lex("%Struct{(x)}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `[...]`" do
      assert lex("%Struct{[x]}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `{...}`" do
      assert lex("%Struct{{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `%{...}`" do
      assert lex("%Struct{%{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `%Struct{...}`" do
      assert lex("%Struct{%Struct{x}}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `#OpaqueStruct<...>`" do
      assert lex("%Struct{#OpaqueStruct< x >}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `<<...>>`" do
      assert lex("%Struct{<< x >>}") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`#OpaqueStruct<...>` + `do ... end`" do
      assert lex("#OpaqueStruct< do x end >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `do ... else ... end`" do
      assert lex("#OpaqueStruct< do x else x end >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `fn ... end`" do
      assert lex("#OpaqueStruct< fn -> x end >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `(...)`" do
      assert lex("#OpaqueStruct< (x) >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `[...]`" do
      assert lex("#OpaqueStruct< [x] >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `{...}`" do
      assert lex("#OpaqueStruct< {x} >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `%{...}`" do
      assert lex("#OpaqueStruct< %{x} >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `%Struct{...}`" do
      assert lex("#OpaqueStruct< %Struct{x} >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `#OpaqueStruct<...>`" do
      assert lex("#OpaqueStruct< #OpaqueStruct< x > >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`#OpaqueStruct<...>` + `<<...>>`" do
      assert lex("#OpaqueStruct< << x >> >") == [
        {:punctuation, %{group_id: "group-1"}, "#"},
        {:name_class, %{group_id: "group-1"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-1"}, "<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">"}
      ]
    end

    test "`<<...>>` + `do ... end`" do
      assert lex("<< do x end >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `do ... else ... end`" do
      assert lex("<< do x else x end >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `fn ... end`" do
      assert lex("<< fn -> x end >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `(...)`" do
      assert lex("<< (x) >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `[...]`" do
      assert lex("<< [x] >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `{...}`" do
      assert lex("<< {x} >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `%{...}`" do
      assert lex("<< %{x} >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `%Struct{...}`" do
      assert lex("<< %Struct{x} >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `#OpaqueStruct<...>`" do
      assert lex("<< #OpaqueStruct< x > >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "#"},
        {:name_class, %{group_id: "group-2"}, "OpaqueStruct"},
        {:punctuation, %{group_id: "group-2"}, "<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `<<...>>`" do
      assert lex("<< << x >> >>") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end
  end
end
