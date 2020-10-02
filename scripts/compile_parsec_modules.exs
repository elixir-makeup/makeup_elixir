defmodule MakeupElixir.Scripts.CompileParsecModules do
  @final_filenames_together [
    "lib/makeup/lexers/elixir_lexer/atoms.ex",
    "lib/makeup/lexers/elixir_lexer/variables.ex"
  ]

  @final_filenames_split [
    "lib/makeup/lexers/elixir_lexer/atoms_start.ex",
    "lib/makeup/lexers/elixir_lexer/atoms_continue.ex",
    "lib/makeup/lexers/elixir_lexer/variables_start.ex",
    "lib/makeup/lexers/elixir_lexer/variables_continue.ex"
  ]

  defp compile_parsec_modules(final_filenames) do
    for file <- final_filenames do
      original_file = file <> ".exs"
      Mix.Tasks.NimbleParsec.Compile.run([original_file])
    end
  end

  defp add_schism(final_filenames, is_split?) do
    Enum.map(final_filenames, fn f ->
      add_schism_to_file_split(f, is_split?)
    end)
  end

  defp add_schism_to_file_split(file, is_split?) do
    original_contents = File.read!(file)

    {split_content, together_content} =
      case is_split? do
        true ->
          {original_contents, "# Nothing"}

        false ->
          {"# Nothing", original_contents}
      end

    new_contents = """
      import Schism
      schism "variables and atoms" do
        dogma "split" do
          #{split_content}
        end

        heresy "together" do
          #{together_content}
        end
      end
      """

    formatted_new_contents = Code.format_string!(new_contents)
    File.write!(file, formatted_new_contents)
  end

  def run() do
    compile_parsec_modules(@final_filenames_split)
    compile_parsec_modules(@final_filenames_together)

    add_schism(@final_filenames_split, true)
    add_schism(@final_filenames_together, false)
  end
end


MakeupElixir.Scripts.CompileParsecModules.run()