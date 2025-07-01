extends Resource
class_name GDGraph

## A flexible directed and weighted graph data structure.
## Can represent undirected graphs by adding edges in both directions.

var _adjacency_list: Dictionary = {}
var _nodes: GDSet


## Constructor for the GDGraph.
func _init():
	_nodes = GDSet.new()


## Adds a node to the graph.
##
## @param node: The node to be added. Must be a hashable type.
## @return: `true` if the node was added, `false` if it already existed.
func add_node(node) -> bool:
	if _nodes.contains(node):
		return false
	_nodes.add(node)
	_adjacency_list[node] = {}
	return true


## Adds an edge between two nodes.
## If the nodes do not exist, they will be added to the graph.
##
## @param from_node: The starting node of the edge.
## @param to_node: The ending node of the edge.
## @param weight: The weight of the edge (default: 1).
## @param directed: If `true`, the edge is one-way. If `false`, an edge is added in the opposite direction as well.
func add_edge(from_node, to_node, weight: float = 1.0, directed: bool = true) -> void:
	add_node(from_node) # Ensures the node exists
	add_node(to_node)   # Ensures the node exists

	_adjacency_list[from_node][to_node] = weight

	if not directed:
		_adjacency_list[to_node][from_node] = weight


## Removes a node and all of its associated edges from the graph.
##
## @param node: The node to remove.
## @return: `true` if the node was removed, `false` if it did not exist.
func remove_node(node) -> bool:
	if not _nodes.contains(node):
		return false

	# Remove all edges pointing to this node
	for other_node in _nodes:
		if _adjacency_list[other_node].has(node):
			_adjacency_list[other_node].erase(node)

	# Remove the node itself and its outgoing edges
	_adjacency_list.erase(node)
	_nodes.remove(node)
	return true


## Removes an edge between two nodes.
##
## @param from_node: The starting node of the edge.
## @param to_node: The ending node of the edge.
## @param directed: If `false`, also removes the edge from `to_node` to `from_node`.
## @return: `true` if the edge was removed, `false` otherwise.
func remove_edge(from_node, to_node, directed: bool = true) -> bool:
	if not has_edge(from_node, to_node):
		return false

	_adjacency_list[from_node].erase(to_node)

	if not directed:
		if has_edge(to_node, from_node):
			_adjacency_list[to_node].erase(from_node)

	return true


## Checks if a node exists in the graph.
##
## @param node: The node to check for.
## @return: `true` if the node exists, `false` otherwise.
func has_node(node) -> bool:
	return _nodes.contains(node)


## Checks if a direct edge exists between two nodes.
##
## @param from_node: The starting node.
## @param to_node: The ending node.
## @return: `true` if the edge exists, `false` otherwise.
func has_edge(from_node, to_node) -> bool:
	return has_node(from_node) and _adjacency_list[from_node].has(to_node)


## Gets the weight of an edge.
##
## @param from_node: The starting node.
## @param to_node: The ending node.
## @return: The weight of the edge, or `INF` if the edge does not exist.
func get_weight(from_node, to_node) -> float:
	if has_edge(from_node, to_node):
		return _adjacency_list[from_node][to_node]
	return INF


## Gets the neighbors of a given node.
##
## @param node: The node whose neighbors to retrieve.
## @return: An array of neighbor nodes. Returns an empty array if the node does not exist.
func get_neighbors(node) -> Array:
	if not has_node(node):
		return []
	return _adjacency_list[node].keys()


## Returns the set of all nodes in the graph.
##
## @return: A GDSet containing all nodes.
func get_nodes() -> GDSet:
	return _nodes.clone()


## Returns the number of nodes in the graph.
##
## @return: The number of nodes.
func size() -> int:
	return _nodes.size()


## Checks if the graph is empty.
##
## @return: `true` if the graph has no nodes, `false` otherwise.
func is_empty() -> bool:
	return _nodes.is_empty()


## Clears the graph of all nodes and edges.
func clear() -> void:
	_adjacency_list.clear()
	_nodes.clear()


## Creates and returns a new GDGraph instance that is a deep copy of this graph.
##
## @return: A new GDGraph with the same structure and elements.
func clone() -> GDGraph:
	var new_graph = GDGraph.new()
	new_graph._nodes = _nodes.clone()
	new_graph._adjacency_list = _adjacency_list.duplicate(true) # Deep copy
	return new_graph


# Iterator implementation (iterates over nodes)

func _iter_init(arg) -> bool:
	return _nodes._iter_init(arg)

func _iter_next(arg) -> bool:
	return _nodes._iter_next(arg)

func _iter_get(arg) -> Variant:
	return _nodes._iter_get(arg)
