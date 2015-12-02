defmodule CypherTest do
  require IEx
  use ExUnit.Case
  doctest Cypher
  @leex_file 'lib/cypher/lexers/cypher_lexer.xrl'

  setup_all do
    {:ok, lexer_path} = :leex.file(@leex_file)
    IEx.Helpers.c(String.Chars.to_string(lexer_path))
    :ok
  end

  test "Can tokenize labels" do
    {:ok, tokens, _} = :cypher_lexer.string(String.to_char_list(":lorem_ipsum"))
    assert tokens == [{:label, 1, 'lorem_ipsum'}]
  end

  test "Can tokenize whole create node statements" do
    create_node = ~S"""
    CREATE (:`Session`:`User` {`email`:"jimbob@email.com", `facebook_id`:"1111111111", `model_id`:1, `uuid`:"b5f898e7-b818-4fd4-93ea-54506526039d"});
    """
    {:ok, tokens, _} = :cypher_lexer.string(String.to_char_list(create_node))
    assert tokens == [
      {:variable, 1, 'CREATE'},
      {:node_open, 1},
      {:label, 1, 'Session'},
      {:label, 1, 'User'},
      {:attributes_open, 1},
      {:attribute, 1, ['email', 'jimbob@email.com']},
      {:comma, 1},
      {:attribute, 1, ['facebook_id', '1111111111']},
      {:comma, 1},
      {:attribute, 1, ['model_id', '1']},
      {:comma, 1},
      {:attribute, 1, ['uuid', 'b5f898e7-b818-4fd4-93ea-54506526039d']},
      {:attributes_close, 1},
      {:node_close, 1},
      {:end_of_command, 1}
    ]
  end

  test "Can tokenize relationship statements" do
    create_node = ~S"""
      MATCH (n1:`Session`{`email`:"jim@lorem.com"}), (n2:`Sport`{`name`:"Quiddich"}) CREATE (n1)-[:`LIKED_SPORT`]->(n2);
    """
    {:ok, tokens, _} = :cypher_lexer.string(String.to_char_list(create_node))

    assert tokens == [
      {:variable, 1, 'MATCH'},
      {:node_open, 1},
        {:variable, 1, 'n1'},
        {:label, 1, 'Session'},
        {:attributes_open, 1},
          {:attribute, 1, ['email', 'jim@lorem.com']},
        {:attributes_close, 1},
      {:node_close, 1},
      {:comma, 1},
      {:node_open, 1},
        {:variable, 1, 'n2'},
        {:label, 1, 'Sport'},
        {:attributes_open, 1},
          {:attribute, 1, ['name', 'Quiddich']},
        {:attributes_close, 1},
      {:node_close, 1},
      {:variable, 1, 'CREATE'},
      {:node_open, 1},
        {:variable, 1, 'n1'},
      {:node_close, 1},
      {:related_to, 1},
      {:relationship_open, 1},
        {:label, 1, 'LIKED_SPORT'},
      {:relationship_close, 1},
      {:parent_of, 1},
      {:node_open, 1},
        {:variable, 1, 'n2'},
      {:node_close, 1},
      {:end_of_command, 1}
    ]
  end

end
