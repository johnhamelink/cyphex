Nonterminals attributes elems elem statement create_action node labels.
Terminals attributes_open attributes_close comma int atom label create node_open node_close.
Rootsymbol statement.

statement -> create_action : '$1'.

create_action -> create node : {create, '$2'}.

node -> node_open node_close : {node, {labels, []}, {attributes, []}}.
node -> node_open labels node_close : {node, {labels, '$2'}, {attributes, []}}.
node -> node_open labels attributes node_close : {node, {labels, '$2'}, {attributes, '$3'}}.

labels -> label       : ['$1'].
labels -> label labels : ['$1'|'$2'].

attributes -> attributes_open attributes_close : [].
attributes -> attributes_open elems attributes_close : '$2'.

elems -> elem           : ['$1'].
elems -> elem comma elems : ['$1'|'$3'].

elem -> label       : extract_token('$1').
elem -> int         : extract_token('$1').
elem -> atom        : extract_token('$1').
elem -> attributes  : '$1'.


Erlang code.

extract_token({_Token, _Line, Value}) -> Value.
