defmodule Makeup.Lexers.ElixirLexer.ElixirLexerGroupsTest do
  # The tests need to be checked manually!!! (remove this line when they've been checked)
  use ExUnit.Case, async: true
  import Makeup.Lexers.ElixirLexer.Testing, only: [lex: 1]
  alias Makeup.Lexer

  describe "all group transitions" do
    test "`do ... end` + `do ... end`" do
      code = "do do x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `do ... else ... end`" do
      code = "do do x else x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `fn ... end`" do
      code = "do fn -> x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `(...)`" do
      code = "do (x) end"

      assert lex(code) == [
               {:keyword, %{group_id: "group-1"}, "do"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-1"}, "end"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `[...]`" do
      code = "do [x] end"

      assert lex(code) == [
               {:keyword, %{group_id: "group-1"}, "do"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-1"}, "end"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `{...}`" do
      code = "do {x} end"

      assert lex(code) == [
               {:keyword, %{group_id: "group-1"}, "do"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-1"}, "end"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `%{...}`" do
      code = "do %{x} end"

      assert lex(code) == [
               {:keyword, %{group_id: "group-1"}, "do"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-1"}, "end"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `%Struct{...}`" do
      code = "do %Struct{x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `#OpaqueStruct<...>`" do
      code = "do #OpaqueStruct< x > end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... end` + `<<...>>`" do
      code = "do << x >> end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `do ... end`" do
      code = "do do x end else do x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `do ... else ... end`" do
      code = "do do x else x end else do x else x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `fn ... end`" do
      code = "do fn -> x end else fn -> x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `(...)`" do
      code = "do (x) else (x) end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `[...]`" do
      code = "do [x] else [x] end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `{...}`" do
      code = "do {x} else {x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `%{...}`" do
      code = "do %{x} else %{x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `%Struct{...}`" do
      code = "do %Struct{x} else %Struct{x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `#OpaqueStruct<...>`" do
      code = "do #OpaqueStruct< x > else #OpaqueStruct< x > end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`do ... else ... end` + `<<...>>`" do
      code = "do << x >> else << x >> end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `do ... end`" do
      code = "fn -> do x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `do ... else ... end`" do
      code = "fn -> do x else x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `fn ... end`" do
      code = "fn -> fn -> x end end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `(...)`" do
      code = "fn -> (x) end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `[...]`" do
      code = "fn -> [x] end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `{...}`" do
      code = "fn -> {x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `%{...}`" do
      code = "fn -> %{x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `%Struct{...}`" do
      code = "fn -> %Struct{x} end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `#OpaqueStruct<...>`" do
      code = "fn -> #OpaqueStruct< x > end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`fn ... end` + `<<...>>`" do
      code = "fn -> << x >> end"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `do ... end`" do
      code = "(do x end)"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:keyword, %{group_id: "group-2"}, "do"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-2"}, "end"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `do ... else ... end`" do
      code = "(do x else x end)"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `fn ... end`" do
      code = "(fn -> x end)"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `(...)`" do
      code = "((x))"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `[...]`" do
      code = "([x])"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `{...}`" do
      code = "({x})"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `%{...}`" do
      code = "(%{x})"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `%Struct{...}`" do
      code = "(%Struct{x})"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-2"}, "%"},
               {:name_class, %{group_id: "group-2"}, "Struct"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `#OpaqueStruct<...>`" do
      code = "(#OpaqueStruct< x >)"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`(...)` + `<<...>>`" do
      code = "(<< x >>)"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "("},
               {:punctuation, %{group_id: "group-2"}, "<<"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, ">>"},
               {:punctuation, %{group_id: "group-1"}, ")"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `do ... end`" do
      code = "[do x end]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:keyword, %{group_id: "group-2"}, "do"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-2"}, "end"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `do ... else ... end`" do
      code = "[do x else x end]"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `fn ... end`" do
      code = "[fn -> x end]"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `(...)`" do
      code = "[(x)]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `[...]`" do
      code = "[[x]]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `{...}`" do
      code = "[{x}]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `%{...}`" do
      code = "[%{x}]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `%Struct{...}`" do
      code = "[%Struct{x}]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:punctuation, %{group_id: "group-2"}, "%"},
               {:name_class, %{group_id: "group-2"}, "Struct"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `#OpaqueStruct<...>`" do
      code = "[#OpaqueStruct< x >]"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`[...]` + `<<...>>`" do
      code = "[<< x >>]"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "["},
               {:punctuation, %{group_id: "group-2"}, "<<"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, ">>"},
               {:punctuation, %{group_id: "group-1"}, "]"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `do ... end`" do
      code = "{do x end}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:keyword, %{group_id: "group-2"}, "do"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-2"}, "end"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `do ... else ... end`" do
      code = "{do x else x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `fn ... end`" do
      code = "{fn -> x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `(...)`" do
      code = "{(x)}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `[...]`" do
      code = "{[x]}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `{...}`" do
      code = "{{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `%{...}`" do
      code = "{%{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `%Struct{...}`" do
      code = "{%Struct{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "%"},
               {:name_class, %{group_id: "group-2"}, "Struct"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `#OpaqueStruct<...>`" do
      code = "{#OpaqueStruct< x >}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`{...}` + `<<...>>`" do
      code = "{<< x >>}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "<<"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, ">>"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `do ... end`" do
      code = "%{do x end}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:keyword, %{group_id: "group-2"}, "do"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:keyword, %{group_id: "group-2"}, "end"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `do ... else ... end`" do
      code = "%{do x else x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `fn ... end`" do
      code = "%{fn -> x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `(...)`" do
      code = "%{(x)}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `[...]`" do
      code = "%{[x]}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `{...}`" do
      code = "%{{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `%{...}`" do
      code = "%{%{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `%Struct{...}`" do
      code = "%{%Struct{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:punctuation, %{group_id: "group-2"}, "%"},
               {:name_class, %{group_id: "group-2"}, "Struct"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `#OpaqueStruct<...>`" do
      code = "%{#OpaqueStruct< x >}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%{...}` + `<<...>>`" do
      code = "%{<< x >>}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%{"},
               {:punctuation, %{group_id: "group-2"}, "<<"},
               {:whitespace, %{}, " "},
               {:name, %{}, "x"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, ">>"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `do ... end`" do
      code = "%Struct{do x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `do ... else ... end`" do
      code = "%Struct{do x else x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `fn ... end`" do
      code = "%Struct{fn -> x end}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `(...)`" do
      code = "%Struct{(x)}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%"},
               {:name_class, %{group_id: "group-1"}, "Struct"},
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `[...]`" do
      code = "%Struct{[x]}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%"},
               {:name_class, %{group_id: "group-1"}, "Struct"},
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `{...}`" do
      code = "%Struct{{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%"},
               {:name_class, %{group_id: "group-1"}, "Struct"},
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `%{...}`" do
      code = "%Struct{%{x}}"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "%"},
               {:name_class, %{group_id: "group-1"}, "Struct"},
               {:punctuation, %{group_id: "group-1"}, "{"},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:punctuation, %{group_id: "group-1"}, "}"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `%Struct{...}`" do
      code = "%Struct{%Struct{x}}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `#OpaqueStruct<...>`" do
      code = "%Struct{#OpaqueStruct< x >}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`%Struct{...}` + `<<...>>`" do
      code = "%Struct{<< x >>}"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `do ... end`" do
      code = "#OpaqueStruct< do x end >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `do ... else ... end`" do
      code = "#OpaqueStruct< do x else x end >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `fn ... end`" do
      code = "#OpaqueStruct< fn -> x end >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `(...)`" do
      code = "#OpaqueStruct< (x) >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `[...]`" do
      code = "#OpaqueStruct< [x] >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `{...}`" do
      code = "#OpaqueStruct< {x} >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `%{...}`" do
      code = "#OpaqueStruct< %{x} >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `%Struct{...}`" do
      code = "#OpaqueStruct< %Struct{x} >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `#OpaqueStruct<...>`" do
      code = "#OpaqueStruct< #OpaqueStruct< x > >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`#OpaqueStruct<...>` + `<<...>>`" do
      code = "#OpaqueStruct< << x >> >"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `do ... end`" do
      code = "<< do x end >>"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `do ... else ... end`" do
      code = "<< do x else x end >>"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `fn ... end`" do
      code = "<< fn -> x end >>"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `(...)`" do
      code = "<< (x) >>"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "<<"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "("},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, ")"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-1"}, ">>"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `[...]`" do
      code = "<< [x] >>"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "<<"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "["},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "]"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-1"}, ">>"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `{...}`" do
      code = "<< {x} >>"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "<<"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-1"}, ">>"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `%{...}`" do
      code = "<< %{x} >>"

      assert lex(code) == [
               {:punctuation, %{group_id: "group-1"}, "<<"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-2"}, "%{"},
               {:name, %{}, "x"},
               {:punctuation, %{group_id: "group-2"}, "}"},
               {:whitespace, %{}, " "},
               {:punctuation, %{group_id: "group-1"}, ">>"}
             ]

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `%Struct{...}`" do
      code = "<< %Struct{x} >>"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `#OpaqueStruct<...>`" do
      code = "<< #OpaqueStruct< x > >>"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end

    test "`<<...>>` + `<<...>>`" do
      code = "<< << x >> >>"

      assert lex(code) == [
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

      assert code |> lex() |> Lexer.unlex() == code
    end
  end
end
