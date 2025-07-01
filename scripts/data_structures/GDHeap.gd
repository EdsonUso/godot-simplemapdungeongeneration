extends Resource
class_name GDHeap

## A Min-Heap data structure.
## The smallest element is always at the root of the heap.
## Operations like push and pop are performed in O(log n) time.

var _data: Array = []
var _iterator_index: int = -1


## Constructor for the GDHeap.
## Can be initialized with an array of values, which will be formed into a heap.
##
## @param initial_array: An array of values to initialize the heap with.
func _init(initial_array: Array = []):
	_data = initial_array.duplicate()
	_build_heap()


## Adds a value to the heap, maintaining the heap property.
##
## @param value: The value to be added.
func push(value) -> void:
	_data.push_back(value)
	_heapify_up(_data.size() - 1)


## Removes and returns the smallest value (the root) from the heap.
##
## @return: The smallest value, or `null` if the heap is empty.
func pop() -> Variant:
	if is_empty():
		push_warning("Cannot pop from an empty GDHeap.")
		return null

	var root = _data[0]
	var last_element = _data.pop_back()

	if not is_empty():
		_data[0] = last_element
		_heapify_down(0)

	return root


## Returns the smallest value from the heap without removing it.
##
## @return: The smallest value, or `null` if the heap is empty.
func peek() -> Variant:
	if is_empty():
		return null
	return _data[0]


## Returns the number of elements in the heap.
##
## @return: The number of elements.
func size() -> int:
	return _data.size()


## Checks if the heap is empty.
##
## @return: `true` if the heap is empty, `false` otherwise.
func is_empty() -> bool:
	return _data.is_empty()


## Clears all elements from the heap.
func clear() -> void:
	_data.clear()


## Creates and returns a new GDHeap instance that is an exact copy of this heap.
##
## @return: A new GDHeap with the same elements.
func clone() -> GDHeap:
	return GDHeap.new(to_array())


## Converts the heap to an Array.
## The returned array is a copy of the internal data structure and is not sorted.
##
## @return: An Array containing all elements of the heap.
func to_array() -> Array:
	return _data.duplicate()


# Private helper methods for heap operations

func _parent_index(i: int) -> int:
	return (i - 1) / 2

func _left_child_index(i: int) -> int:
	return 2 * i + 1

func _right_child_index(i: int) -> int:
	return 2 * i + 2

func _swap(i: int, j: int) -> void:
	var temp = _data[i]
	_data[i] = _data[j]
	_data[j] = temp


## Moves an element up the heap to its correct position.
func _heapify_up(index: int) -> void:
	var parent_idx = _parent_index(index)
	while index > 0 and _data[index] < _data[parent_idx]:
		_swap(index, parent_idx)
		index = parent_idx
		parent_idx = _parent_index(index)


## Moves an element down the heap to its correct position.
func _heapify_down(index: int) -> void:
	var min_index = index
	while true:
		var left_idx = _left_child_index(index)
		var right_idx = _right_child_index(index)

		if left_idx < _data.size() and _data[left_idx] < _data[min_index]:
			min_index = left_idx

		if right_idx < _data.size() and _data[right_idx] < _data[min_index]:
			min_index = right_idx

		if index != min_index:
			_swap(index, min_index)
			index = min_index
		else:
			break


## Builds the heap from an unordered array.
func _build_heap() -> void:
	var start_index = (_data.size() / 2) - 1
	for i in range(start_index, -1, -1):
		_heapify_down(i)


# Iterator implementation

func _iter_init(_arg) -> bool:
	_iterator_index = -1
	return true

func _iter_next(_arg) -> bool:
	_iterator_index += 1
	return _iterator_index < _data.size()

func _iter_get(_arg) -> Variant:
	return _data[_iterator_index]
