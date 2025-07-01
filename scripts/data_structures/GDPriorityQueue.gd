extends Resource
class_name GDPriorityQueue

## A Priority Queue data structure, implemented using a Min-Heap.
## Items are enqueued with a value and a priority.
## Items with a lower priority value are dequeued first.

var _heap: GDHeap


## Constructor for the GDPriorityQueue.
func _init():
	_heap = GDHeap.new()


## Adds a value to the queue with an associated priority.
##
## @param value: The value to be stored.
## @param priority: The priority of the value. Lower numbers mean higher priority.
func enqueue(value, priority: int) -> void:
	# The heap will sort based on the first element of the array, which is the priority.
	_heap.push([priority, value])


## Removes and returns the value with the highest priority (lowest priority number).
##
## @return: The value with the highest priority, or `null` if the queue is empty.
func dequeue() -> Variant:
	if is_empty():
		push_warning("Cannot dequeue from an empty GDPriorityQueue.")
		return null

	var item = _heap.pop()
	return item[1] # Return the value, not the [priority, value] pair


## Returns the value with the highest priority without removing it.
##
## @return: The value with the highest priority, or `null` if the queue is empty.
func peek() -> Variant:
	if is_empty():
		return null

	var item = _heap.peek()
	return item[1] # Return the value


## Returns the number of elements in the queue.
##
## @return: The number of elements.
func size() -> int:
	return _heap.size()


## Checks if the queue is empty.
##
## @return: `true` if the queue is empty, `false` otherwise.
func is_empty() -> bool:
	return _heap.is_empty()


## Clears all elements from the queue.
func clear() -> void:
	_heap.clear()


## Creates and returns a new GDPriorityQueue instance that is an exact copy of this one.
##
## @return: A new GDPriorityQueue with the same elements and priorities.
func clone() -> GDPriorityQueue:
	var new_queue = GDPriorityQueue.new()
	# We clone the internal heap to create a new, independent priority queue.
	new_queue._heap = _heap.clone()
	return new_queue
