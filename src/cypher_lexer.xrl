Definitions.

NUMBER     = [0-9\.]+
LABEL      = \:["'`]?[a-zA-Z-_]+["'`]?
WHITESPACE = [\s\t\n\r]
STRING     = [\'\`\"](\\.|[^\'\`\"])*[\'\`\"]
VARIABLE   = [a-zA-Z_][a-zA-Z_0-9]+


Rules.

{NUMBER}             : {token, {number,  TokenLine, TokenChars}}.
{LABEL}              : {token, {label, TokenLine, remove_quotes(tail(TokenChars))}}.
{STRING}             : {token, {string, TokenLine, remove_quotes(TokenChars)}}.
{STRING}\:{WHITESPACE}*{STRING}   : {token, {attribute, TokenLine, key_value(TokenChars)}}.
{STRING}\:{WHITESPACE}*{NUMBER}   : {token, {attribute, TokenLine, key_value(TokenChars)}}.
CREATE               : {token, {create, TokenLine}}.
MATCH                : {token, {match, TokenLine}}.
RETURN               : {token, {return, TokenLine}}.
\(                   : {token, {node_open, TokenLine}}.
\)                   : {token, {node_close, TokenLine}}.
\{                   : {token, {attributes_open, TokenLine}}.
\}                   : {token, {attributes_close, TokenLine}}.
\,                   : {token, {comma, TokenLine}}.
\;                   : {token, {end_of_command, TokenLine}}.
\[                   : {token, {relationship_open, TokenLine}}.
\]                   : {token, {relationship_close, TokenLine}}.
\-\>                 : {token, {parent_of, TokenLine}}.
\<\-                 : {token, {child_of, TokenLine}}.
\-                   : {token, {related_to, TokenLine}}.
DROP                 : skip_token.
REMOVE               : skip_token.
begin                : skip_token.
commit               : skip_token.
schema               : skip_token.
await                : skip_token.
\#(.+)               : skip_token.
{VARIABLE}           : {token, {variable, TokenLine, TokenChars}}.
{WHITESPACE}+        : skip_token.

Erlang code.

%% Remove quotation marks from a string
remove_quotes(Chars) ->
  re:replace(
    re:replace(
      strip_whitespace(Chars),
      "[\"\'\`]$",
      "",
      [{return, list}]
    ),
    "^[\"\'\`]",
    "",
    [{return, list}]
  ).

%% Remove the first char from a string
tail([_|T]) ->
  T.

%% Strip spaces
strip_whitespace(Chars) ->
  string:strip(Chars, both, $ ).

% Produce a key/value tuple
key_value([_|Chars]) ->
  [Key, Value] = string:tokens(Chars, ":"),
  [ remove_quotes(Key), remove_quotes(Value) ].
