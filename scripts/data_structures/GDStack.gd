extends Resource
class_name GDStack

## A LIFO (Last-In, First-Out) stack data structure.
## Provides simple and efficient stack operations.

var _data: Array = []
var _iterator_index: int = -1


## Constructor for the GDStack.
## Can be initialized with an array of values, which will be pushed onto the stack.
##
## @param initial_array: An array of values to initialize the stack with.
func _init(initial_array: Array = []):
	for item in initial_array:
		push(item)


## Adds a value to the top of the stack.
##
## @param value: The value to be pushed onto the stack.
func push(value) -> void:
	_data.push_back(value)


## Removes and returns the value at the top of the stack.
##
## @return: The value from the top of the stack, or `null` if the stack is empty.
func pop() -> Variant:
	if is_empty():
		push_warning("Cannot pop from an empty GDStack.")
		return null
	return _data.pop_back()


## Returns the value at the top of the stack without removing it.
##
## @return: The value from the top of the stack, or `null` if the stack is empty.
func peek() -> Variant:
	if is_empty():
		return null
	return _data.back()


## Returns the number of elements in the stack.
##
## @return: The number of elements.
func size() -> int:
	return _data.size()


## Checks if the stack is empty.
##
## @return: `true` if the stack contains no elements, `false` otherwise.
func is_empty() -> bool:
	return _data.is_empty()


## Clears all elements from the stack.
func clear() -> void:
	_data.clear()


## Creates and returns a new GDStack instance that is an exact copy of this stack.
##
## @return: A new GDStack with the same elements.
func clone() -> GDStack:
	return GDStack.new(to_array())


## Converts the stack to an Array.
## The returned array is a copy; modifying it will not affect the original stack.
## The order of the elements reflects the stack, with the top element being the last in the array.
##
## @return: An Array containing all elements of the stack.
func to_array() -> Array:
	return _data.duplicate()


## Initializes the iterator for the Stack.
## This is called automatically at the start of a `for` loop.
## Iteration happens from top to bottom (LIFO).
##
## @param _arg: The argument passed to the iterator (unused).
## @return: `true` if the iterator was successfully initialized.
func _iter_init(_arg) -> bool:
	_iterator_index = _data.size()
	return true


## Advances the iterator to the next element.
## This is called automatically during a `for` loop.
##
## @param _arg: The argument passed to the iterator (unused).
## @return: `true` if there is a next element, `false` otherwise.
func _iter_next(_arg) -> bool:
	_iterator_index -= 1
	return _iterator_index >= 0


## Gets the current value of the element in the iteration.
## This is called automatically during a `for` loop.
##
## @param _arg: The argument passed to the iterator (unused).
## @return: The current element.
func _iter_get(_arg) -> Variant:
	return _data[_iterator_index]
