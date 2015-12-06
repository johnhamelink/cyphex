defmodule Cyphex.Lexer do

  def string(string) when is_binary(string) do
    :cypher_lexer.string(String.to_char_list(string))
  end

  def string(string, start_line) when is_binary(string) and is_number(start_line) do
    :cypher_lexer.string(String.to_char_list(string, start_line))
  end

  def tokens(cont, string, start_line) when is_tuple(cont) and is_binary(string) and is_number(start_line) do
    :cypher_lexer.tokens(cont, String.to_char_list(string), start_line)
  end

  def tokens(cont, string) when is_tuple(cont) and is_binary(string) do
    :cypher_lexer.tokens(cont, String.to_char_list(string))
  end

  def token(cont, string, start_line) when is_tuple(cont) and is_binary(string) and is_number(start_line) do
    :cypher_lexer.token(cont, String.to_char_list(string), start_line)
  end

  def token(cont, string) when is_tuple(cont) and is_binary(string) do
    :cypher_lexer.token(cont, String.to_char_list(string))
  end

end
