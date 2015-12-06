defmodule Cyphex.Parser do

  def parse(lex) when is_tuple(lex) or is_list(lex) do
    :cypher_parser.parse(lex)
  end

end
