defmodule Cypher.LexerTest do
  use ExUnit.Case
  alias Cyphex.Lexer

  test "tokenizes labels" do
    {:ok, tokens, _} = Lexer.string(":lorem_ipsum")
    assert tokens == [{:label, 1, 'lorem_ipsum'}]
  end

  test "tokenizes create node statements" do
    create_node = ~S"""
    CREATE (:`Session`:`User` {`email`:"jimbob@email.com", `facebook_id`:"1111111111", `model_id`:1, `uuid`:"b5f898e7-b818-4fd4-93ea-54506526039d"});
    """
    {:ok, tokens, _} = Lexer.string(create_node)
    assert tokens == [
      {:create, 1},
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

  test "tokenizes relationship statements" do
    create_node = ~S"""
      MATCH (n1:`Session`{`email`:"jim@lorem.com"}), (n2:`Sport`{`name`:"Quiddich"}) CREATE (n1)-[:`LIKED_SPORT`]->(n2);
    """
    {:ok, tokens, _} = Lexer.string(create_node)

    assert tokens == [
      {:match, 1},
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
      {:create, 1},
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

  test "multiple lines" do
    create_node = ~S"""
      CREATE (:`Session`:`User` {`email`:"jimbob@email.com", `facebook_id`:"1111111111", `model_id`:1, `uuid`:"b5f898e7-b818-4fd4-93ea-54506526039d"});
      MATCH (n1:`Session`{`email`:"jim@lorem.com"}), (n2:`Sport`{`name`:"Quiddich"}) CREATE (n1)-[:`LIKED_SPORT`]->(n2);
    """
    {:ok, tokens, _} = Lexer.string(create_node)

    assert tokens == [
      {:create, 1},
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
      {:end_of_command, 1},

      {:match, 2},
      {:node_open, 2},
        {:variable, 2, 'n1'},
        {:label, 2, 'Session'},
        {:attributes_open, 2},
          {:attribute, 2, ['email', 'jim@lorem.com']},
        {:attributes_close, 2},
      {:node_close, 2},
      {:comma, 2},
      {:node_open, 2},
        {:variable, 2, 'n2'},
        {:label, 2, 'Sport'},
        {:attributes_open, 2},
          {:attribute, 2, ['name', 'Quiddich']},
        {:attributes_close, 2},
      {:node_close, 2},
      {:create, 2},
      {:node_open, 2},
        {:variable, 2, 'n1'},
      {:node_close, 2},
      {:related_to, 2},
      {:relationship_open, 2},
        {:label, 2, 'LIKED_SPORT'},
      {:relationship_close, 2},
      {:parent_of, 2},
      {:node_open, 2},
        {:variable, 2, 'n2'},
      {:node_close, 2},
      {:end_of_command, 2}
    ]

  end

  test "ignores comments" do
    create_node = ~S"""
      # Comment taking whole line here.
      CREATE (:`Session`:`User`); # Comment appended to line here
    """
    {:ok, tokens, _} = Lexer.string(create_node)
    assert tokens == [
      {:create, 2},
      {:node_open, 2},
      {:label, 2, 'Session'},
      {:label, 2, 'User'},
      {:node_close, 2},
      {:end_of_command, 2}
    ]
  end

end
