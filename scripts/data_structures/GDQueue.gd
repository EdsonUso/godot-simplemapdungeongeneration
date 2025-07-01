
extends Resource
class_name GDQueue

## A FIFO (First-In, First-Out) queue data structure.
## Implemented with a linked list for efficient O(1) enqueue and dequeue operations.

# --- Inner class for the linked list nodes ---
class QueueNode:
	var value
	var next = null
	func _init(v):
		value = v
# -------------------------------------------

var _head: QueueNode = null
var _tail: QueueNode = null
var _count: int = 0

var _iterator_current_node: QueueNode = null


## Constructor for the GDQueue.
## Can be initialized with an array of values.
##
## @param initial_array: An array of values to initialize the queue with.
func _init(initial_array: Array = []):
	for item in initial_array:
		enqueue(item)


## Adds a value to the end of the queue.
##
## @param value: The value to be added.
func enqueue(value) -> void:
	var new_node = QueueNode.new(value)
	if is_empty():
		_head = new_node
		_tail = new_node
	else:
		_tail.next = new_node
		_tail = new_node
	_count += 1


## Removes and returns the value from the front of the queue.
##
## @return: The value from the front of the queue, or `null` if it's empty.
func dequeue() -> Variant:
	if is_empty():
		push_warning("Cannot dequeue from an empty GDQueue.")
		return null

	var node_to_remove = _head
	_head = _head.next
	_count -= 1

	if is_empty():
		_tail = null

	return node_to_remove.value


## Returns the value at the front of the queue without removing it.
##
## @return: The value from the front of the queue, or `null` if it's empty.
func peek() -> Variant:
	if is_empty():
		return null
	return _head.value


## Returns the number of elements in the queue.
##
## @return: The number of elements.
func size() -> int:
	return _count


## Checks if the queue is empty.
##
## @return: `true` if the queue is empty, `false` otherwise.
func is_empty() -> bool:
	return _count == 0


## Clears all elements from the queue.
func clear() -> void:
	_head = null
	_tail = null
	_count = 0


## Creates and returns a new GDQueue instance that is an exact copy of this queue.
##
## @return: A new GDQueue with the same elements.
func clone() -> GDQueue:
	var new_queue = GDQueue.new()
	var current = _head
	while current != null:
		new_queue.enqueue(current.value)
		current = current.next
	return new_queue


## Converts the queue to an Array.
## The order reflects the queue, with the front element being the first in the array.
##
## @return: An Array containing all elements of the queue.
func to_array() -> Array:
	var arr = []
	var current = _head
	while current != null:
		arr.push_back(current.value)
		current = current.next
	return arr


# Iterator implementation

func _iter_init(_arg) -> bool:
	# Start the iterator in a state "before" the head.
	# The first call to _iter_next will advance it to the actual head.
	_iterator_current_node = null
	# If head is null, the first _iter_next will correctly return false.
	if _head != null:
		# Create a dummy node to point to the head, so the logic in _iter_next is consistent.
		_iterator_current_node = QueueNode.new(null)
		_iterator_current_node.next = _head
	return true


func _iter_next(_arg) -> bool:
	if _iterator_current_node == null:
		return false
	_iterator_current_node = _iterator_current_node.next
	return _iterator_current_node != null


func _iter_get(_arg) -> Variant:
	if _iterator_current_node == null:
		return null # Should not happen with correct loop mechanics
	return _iterator_current_node.value
