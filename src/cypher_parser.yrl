Nonterminals attributes elems elem statement create_action match_action node nodes labels create_relation relation rel_operator relation_edge node_content node_contents variables relationship.
Terminals attributes_open attribute attributes_close comma int atom label match create node_open node_close variable parent_of child_of related_to relationship_open relationship_close.
Rootsymbol statement.

statement -> create_action : '$1'.
statement -> match_action  : '$1'.

create_action -> create node : {create, '$2'}.
match_action  -> match nodes create_relation : {match, '$2', '$3'}.
create_relation -> create relationship : {relation, '$1', '$2'}.

relationship -> node relation node : ['$1', '$2', '$3'].
relation -> rel_operator relation_edge rel_operator : {rel, ['$1', '$2', '$3']}.

rel_operator -> parent_of  : extract_token('$1').
rel_operator -> child_of   : extract_token('$1').
rel_operator -> related_to : extract_token('$1').

relation_edge -> relationship_open label relationship_close : '$2'.

nodes -> node : ['$1'].
nodes -> node comma nodes : ['$1'|'$3'].

node -> node_open node_close : {node}.

node -> node_open node_contents node_close : {node, '$2'}.

node_contents -> node_content : '$1'.
node_contents -> node_content node_contents : ['$1'|'$2'].

node_content -> variables  : '$1'.
node_content -> labels     : '$1'.
node_content -> attributes : '$1'.

labels -> label        : ['$1'].
labels -> label labels : ['$1'|'$2'].

variables -> variable: ['$1'].
variables -> variable variables : ['$1' | '$2'].

attributes -> attributes_open attributes_close : [].
attributes -> attributes_open elems attributes_close : '$2'.

elems -> elem           : ['$1'].
elems -> elem comma elems : ['$1'|'$3'].

elem -> label       : extract_value('$1').
elem -> int         : extract_value('$1').
elem -> atom        : extract_value('$1').
elem -> attribute   : '$1'.

Erlang code.

extract_value({_Token, _Line, Value}) -> Value.
extract_token({Token, _Line}) -> Token.
