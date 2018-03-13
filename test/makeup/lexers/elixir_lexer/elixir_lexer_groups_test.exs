defmodule Makeup.Lexers.ElixirLexer.ElixirLexerGroupsTest do
  # The tests need to be checked manually!!!
  use ExUnit.Case, async: true
  alias Makeup.Lexers.ElixirLexer

  describe "all group transitions" do

    test "`do ... end` + `do ... end`" do
      assert ElixirLexer.lex("do do x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do do x else x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do fn -> x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do (x) end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do [x] end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do {x} end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do %{x} end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do %Struct{x} end", group_prefix: "group") == [
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

    test "`do ... end` + `<<...>>`" do
      assert ElixirLexer.lex("do <<x>> end", group_prefix: "group") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`do ... else ... end` + `do ... end`" do
      assert ElixirLexer.lex("do do x end else do x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do do x else x end else do x else x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do fn -> x end else fn -> x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do (x) else (x) end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do [x] else [x] end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do {x} else {x} end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do %{x} else %{x} end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("do %Struct{x} else %Struct{x} end", group_prefix: "group") == [
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

    test "`do ... else ... end` + `<<...>>`" do
      assert ElixirLexer.lex("do <<x>> else <<x>> end", group_prefix: "group") == [
        {:keyword, %{group_id: "group-1"}, "do"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "else"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-3"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-3"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`fn ... end` + `do ... end`" do
      assert ElixirLexer.lex("fn -> do x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> do x else x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> fn -> x end end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> (x) end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> [x] end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> {x} end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> %{x} end", group_prefix: "group") == [
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
      assert ElixirLexer.lex("fn -> %Struct{x} end", group_prefix: "group") == [
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

    test "`fn ... end` + `<<...>>`" do
      assert ElixirLexer.lex("fn -> <<x>> end", group_prefix: "group") == [
        {:keyword, %{group_id: "group-1"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-1"}, "end"}
      ]
    end

    test "`(...)` + `do ... end`" do
      assert ElixirLexer.lex("(do x end)", group_prefix: "group") == [
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
      assert ElixirLexer.lex("(do x else x end)", group_prefix: "group") == [
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
      assert ElixirLexer.lex("(fn -> x end)", group_prefix: "group") == [
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
      assert ElixirLexer.lex("((x))", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `[...]`" do
      assert ElixirLexer.lex("([x])", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `{...}`" do
      assert ElixirLexer.lex("({x})", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `%{...}`" do
      assert ElixirLexer.lex("(%{x})", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `%Struct{...}`" do
      assert ElixirLexer.lex("(%Struct{x})", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`(...)` + `<<...>>`" do
      assert ElixirLexer.lex("(<<x>>)", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "("},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, ")"}
      ]
    end

    test "`[...]` + `do ... end`" do
      assert ElixirLexer.lex("[do x end]", group_prefix: "group") == [
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
      assert ElixirLexer.lex("[do x else x end]", group_prefix: "group") == [
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
      assert ElixirLexer.lex("[fn -> x end]", group_prefix: "group") == [
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
      assert ElixirLexer.lex("[(x)]", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `[...]`" do
      assert ElixirLexer.lex("[[x]]", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `{...}`" do
      assert ElixirLexer.lex("[{x}]", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `%{...}`" do
      assert ElixirLexer.lex("[%{x}]", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `%Struct{...}`" do
      assert ElixirLexer.lex("[%Struct{x}]", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`[...]` + `<<...>>`" do
      assert ElixirLexer.lex("[<<x>>]", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "["},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "]"}
      ]
    end

    test "`{...}` + `do ... end`" do
      assert ElixirLexer.lex("{do x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("{do x else x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("{fn -> x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("{(x)}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `[...]`" do
      assert ElixirLexer.lex("{[x]}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `{...}`" do
      assert ElixirLexer.lex("{{x}}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `%{...}`" do
      assert ElixirLexer.lex("{%{x}}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`{...}` + `%Struct{...}`" do
      assert ElixirLexer.lex("{%Struct{x}}", group_prefix: "group") == [
        {:error, %{}, "{"},
        {"{", {:punctuation, %{}, "%"}, :punctuation},
        {"{", {:name_class, %{}, "Struct"}, :punctuation},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-1"}, "}"},
        {:punctuation, %{}, "}"}
      ]
    end

    test "`{...}` + `<<...>>`" do
      assert ElixirLexer.lex("{<<x>>}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `do ... end`" do
      assert ElixirLexer.lex("%{do x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%{do x else x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%{fn -> x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%{(x)}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `[...]`" do
      assert ElixirLexer.lex("%{[x]}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `{...}`" do
      assert ElixirLexer.lex("%{{x}}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `%{...}`" do
      assert ElixirLexer.lex("%{%{x}}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%{...}` + `%Struct{...}`" do
      assert ElixirLexer.lex("%{%Struct{x}}", group_prefix: "group") == [
        {:punctuation, %{}, "%"},
        {:error, %{}, "{"},
        {"{", {:punctuation, %{}, "%"}, :punctuation},
        {"{", {:name_class, %{}, "Struct"}, :punctuation},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-1"}, "}"},
        {:punctuation, %{}, "}"}
      ]
    end

    test "`%{...}` + `<<...>>`" do
      assert ElixirLexer.lex("%{<<x>>}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "%{"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`%Struct{...}` + `do ... end`" do
      assert ElixirLexer.lex("%Struct{do x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{do x else x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{fn -> x end}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{(x)}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{[x]}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{{x}}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{%{x}}", group_prefix: "group") == [
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
      assert ElixirLexer.lex("%Struct{%Struct{x}}", group_prefix: "group") == [
        {:punctuation, %{}, "%"},
        {:name_class, %{}, "Struct"},
        {:error, %{}, "{"},
        {"{", {:punctuation, %{}, "%"}, :punctuation},
        {"{", {:name_class, %{}, "Struct"}, :punctuation},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-1"}, "}"},
        {:punctuation, %{}, "}"}
      ]
    end

    test "`%Struct{...}` + `<<...>>`" do
      assert ElixirLexer.lex("%Struct{<<x>>}", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "%"},
        {:name_class, %{group_id: "group-1"}, "Struct"},
        {:punctuation, %{group_id: "group-1"}, "{"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, "}"}
      ]
    end

    test "`<<...>>` + `do ... end`" do
      assert ElixirLexer.lex("<<do x end>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `do ... else ... end`" do
      assert ElixirLexer.lex("<<do x else x end>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:keyword, %{group_id: "group-2"}, "do"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "else"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `fn ... end`" do
      assert ElixirLexer.lex("<<fn -> x end>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:keyword, %{group_id: "group-2"}, "fn"},
        {:whitespace, %{}, " "},
        {:operator, %{}, "->"},
        {:whitespace, %{}, " "},
        {:name, %{}, "x"},
        {:whitespace, %{}, " "},
        {:keyword, %{group_id: "group-2"}, "end"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `(...)`" do
      assert ElixirLexer.lex("<<(x)>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:punctuation, %{group_id: "group-2"}, "("},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ")"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `[...]`" do
      assert ElixirLexer.lex("<<[x]>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:punctuation, %{group_id: "group-2"}, "["},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "]"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `{...}`" do
      assert ElixirLexer.lex("<<{x}>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `%{...}`" do
      assert ElixirLexer.lex("<<%{x}>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:punctuation, %{group_id: "group-2"}, "%{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `%Struct{...}`" do
      assert ElixirLexer.lex("<<%Struct{x}>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:punctuation, %{group_id: "group-2"}, "%"},
        {:name_class, %{group_id: "group-2"}, "Struct"},
        {:punctuation, %{group_id: "group-2"}, "{"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, "}"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end

    test "`<<...>>` + `<<...>>`" do
      assert ElixirLexer.lex("<<<<x>>>>", group_prefix: "group") == [
        {:punctuation, %{group_id: "group-1"}, "<<"},
        {:punctuation, %{group_id: "group-2"}, "<<"},
        {:name, %{}, "x"},
        {:punctuation, %{group_id: "group-2"}, ">>"},
        {:punctuation, %{group_id: "group-1"}, ">>"}
      ]
    end
  end
end
