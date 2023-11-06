#!/usr/bin/env bash
cat <<EOL
#!/usr/bin/env -S dot -Tsvg -O

digraph {
// attributes
/// graph
rankdir=BT;
/// subgraph
newrank=true;
style=filled;
//// color name: https://graphviz.org/doc/info/colors.html
color=whitesmoke;
/// node
node[
shape=box,
style="filled, solid",
color=black,
fillcolor=white,
];
/// edge
edge[
minlen=1,
//weight=1,
// If false, the edge is not used in ranking the nodes.
//constraint=true,
];



}
EOL
