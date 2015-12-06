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
    query = ~s"""
    CREATE (:User:Toast)
    """
    {:ok, tokens, _line} = Lexer.string(query)
    {:ok, ast} = :cypher_parser.parse(tokens)
    assert ast == {
      :create, {
        :node,
        [ {:label, 1, 'User'}, {:label, 1, 'Toast'} ],
      }
    }
  end

  test "CREATE statements with attributes" do
    query = ~S"""
      CREATE (:User:Toast {`email`:'john@doe.com', `lorem`:'ipsum'})
    """
    {:ok, tokens, _line} = Lexer.string(query)
    {:ok, ast} = :cypher_parser.parse(tokens)
    assert ast == {
      :create,
      {:node,
        [
          [
            {:label, 1, 'User'}, {:label, 1, 'Toast'}
          ],
          {:attribute, 1, ['email', 'john@doe.com']},
          {:attribute, 1, ['lorem', 'ipsum']}
        ]
      }
    }
  end

  test "MATCH statements" do
    query = ~S"""
      MATCH (n1:`Session`{`email`:"jim@lorem.com"}), (n2:`Sport`{`name`:"Quiddich"}) CREATE (n1)-[:`LIKED_SPORT`]->(n2)
    """
    {:ok, tokens, _line} = Lexer.string(query)
    {:ok, ast} = :cypher_parser.parse(tokens)
    assert ast == {:match, [
        node: [
          [
            {:variable, 1, 'n1'}
          ],
          [
            {:label, 1, 'Session'}
          ],
          {:attribute, 1, ['email', 'jim@lorem.com']}
        ],
        node: [
          [
            {:variable, 1, 'n2'}
          ],
          [
            {:label, 1, 'Sport'}
          ],
          {:attribute, 1, ['name', 'Quiddich']}
        ]
      ],
      {
        :relation,
        {:create, 1},
        [
          {:node, [{:variable, 1, 'n1'}]},
          {:rel, [:related_to, {:label, 1, 'LIKED_SPORT'}, :parent_of]},
          {:node, [{:variable, 1, 'n2'}]}
        ]
      }
    }
  end

end
