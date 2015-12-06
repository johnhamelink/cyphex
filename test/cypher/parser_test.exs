defmodule Cypher.ParserTest do
  use ExUnit.Case
  alias Cyphex.Lexer

  @yecc_file 'src/cypher_parser.yrl'

  setup_all do
    {:ok, lexer_path} = :yecc.file(@yecc_file)
    IEx.Helpers.c(String.Chars.to_string(lexer_path))
    :ok
  end

  test "CREATE statements" do
    {:ok, tokens, _line} = Lexer.string("CREATE (:User:Toast)")
    assert :cypher_parser.parse(tokens) == {
      :ok,
      {
        :create, {
          :node,
          { :labels, [ {:label, 1, 'User'}, {:label, 1, 'Toast'} ] },
          { :attributes, [] }
        }
      }
    }
  end

end
