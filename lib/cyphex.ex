defmodule Cyphex do

  def parse(cypher) when is_bitstring(cypher) do
    {:ok, lex} = Cyphex.Lexer.string(cypher)
    Cyphex.Parser.parse(lex)
  end

end
