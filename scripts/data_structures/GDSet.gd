
extends Resource
class_name GDSet

signal element_added(value)
signal element_removed(value)

var _data: Dictionary = {}
var _read_only: bool = false
var _keys_for_iterator: Array = []
var _iterator_index: int = -1


## Constructor for the GDSet.
## Can be initialized with an array of values.
##
## @param initial_array: An array of values to initialize the Set with.
func _init(initial_array: Array = []):
	add_all(initial_array)


## Adds a value to the Set.
## If the value already exists, it will not be added again (ensuring uniqueness).
## Emits the `element_added` signal if a new element is added.
##
## @param value: The value to be added.
func add(value) -> void:
	if _read_only:
		push_error("Cannot modify a read-only GDSet.")
		return
	if not _data.has(value):
		_data[value] = true
		emit_signal("element_added", value)


## Adds all values from an array to the Set.
## Emits the `element_added` signal for each new element added.
##
## @param array: The array of values to be added.
func add_all(array: Array) -> void:
	if _read_only:
		push_error("Cannot modify a read-only GDSet.")
		return
	for value in array:
		# Directly check and add to avoid function call overhead of self.add()
		if not _data.has(value):
			_data[value] = true
			emit_signal("element_added", value)


## Checks if a value is present in the Set.
## This method is used internally by the `in` operator.
##
## @param value: The value to check for.
## @return: `true` if the value is in the Set, `false` otherwise.
func _has(value) -> bool:
	return _data.has(value)


## Alias for `_has(value)` for compatibility.
##
## @param value: The value to check for.
## @return: `true` if the value is in the Set, `false` otherwise.
func contains(value) -> bool:
	return _has(value)


## Removes a value from the Set.
## Emits the `element_removed` signal if an element is removed.
##
## @param value: The value to be removed.
func remove(value) -> void:
	if _read_only:
		push_error("Cannot modify a read-only GDSet.")
		return
	if _data.has(value):
		_data.erase(value)
		emit_signal("element_removed", value)


## Returns the number of elements in the Set.
##
## @return: The number of elements.
func size() -> int:
	return _data.size()


## Clears all elements from the Set.
## Emits the `element_removed` signal for each removed element.
func clear() -> void:
	if _read_only:
		push_error("Cannot modify a read-only GDSet.")
		return
	# Emit signals before clearing to avoid creating a temporary array copy.
	for value in _data:
		emit_signal("element_removed", value)
	_data.clear()


## Converts the Set to an Array.
## The order of elements in the array is not guaranteed.
##
## @return: An Array containing all elements of the Set.
func to_array() -> Array:
	return _data.keys()


## Converts the Set to a Dictionary.
## The dictionary keys are the Set elements, and the values are `true`.
##
## @return: A Dictionary representing the Set.
func to_dictionary() -> Dictionary:
	return _data.duplicate() # Return a duplicate to prevent external modification


## Creates and returns a new GDSet instance that is an exact copy of this Set.
##
## @return: A new GDSet with the same elements.
func clone() -> GDSet:
	var new_set = GDSet.new()
	new_set._data = self._data.duplicate()
	new_set._read_only = self._read_only
	return new_set


## Compares this Set with another GDSet to check if they contain the same elements.
## This is significantly faster than iterating, as it uses a direct Dictionary comparison.
##
## @param other_set: The other GDSet to compare against.
## @return: `true` if both Sets contain the same elements, `false` otherwise.
func equals(other_set: GDSet) -> bool:
	if not other_set is GDSet:
		return false
	# Direct dictionary comparison is much faster than iterating and checking contains.
	return self._data == other_set._data


## Returns a new Set containing all elements that are in either this Set or the other Set (union).
## This is faster than the previous implementation as it uses the built-in Dictionary.merge method.
##
## @param other_set: The other GDSet for the union operation.
## @return: A new GDSet resulting from the union.
func union(other_set: GDSet) -> GDSet:
	var new_set = GDSet.new()
	new_set._data = self._data.duplicate()
	new_set._data.merge(other_set._data) # Use the efficient, built-in merge operation
	return new_set


## Returns a new Set containing elements that are common to both Sets (intersection).
##
## @param other_set: The other GDSet for the intersection operation.
## @return: A new GDSet resulting from the intersection.
func intersection(other_set: GDSet) -> GDSet:
	var new_set = GDSet.new()
	# Iterate over the smaller set for better performance
	var smaller_set = self if self.size() < other_set.size() else other_set
	var larger_set = other_set if self.size() < other_set.size() else self
	for value in smaller_set:
		if larger_set.contains(value):
			new_set.add(value)
	return new_set


## Returns a new Set containing elements that are in this Set but not in `other_set` (difference).
##
## @param other_set: The other GDSet for the difference operation.
## @return: A new GDSet resulting from the difference.
func difference(other_set: GDSet) -> GDSet:
	var new_set = GDSet.new()
	for value in self:
		if not other_set.contains(value):
			new_set.add(value)
	return new_set


## Returns a new Set containing elements that are in one Set or the other, but not both (symmetric difference).
##
## @param other_set: The other GDSet for the XOR operation.
## @return: A new GDSet resulting from the symmetric difference.
func xor(other_set: GDSet) -> GDSet:
	var new_set = GDSet.new()
	for value in self:
		if not other_set.contains(value):
			new_set.add(value)
	for value in other_set:
		if not contains(value):
			new_set.add(value)
	return new_set


## Applies a callback function to each element of the Set and returns a new GDSet with the results.
## The callback function must accept one argument (the element) and return the transformed value.
##
## @param callback: The Callable function to be applied to each element.
## @return: A new GDSet with the transformed elements.
func map(callback: Callable) -> GDSet:
	var new_set = GDSet.new()
	for value in self:
		new_set.add(callback.call(value))
	return new_set


## Filters the elements of the Set based on a callback function and returns a new GDSet.
## The callback function must accept one argument (the element) and return `true` to include the element,
## or `false` to exclude it.
##
## @param callback: The Callable function to filter the elements.
## @return: A new GDSet containing only the elements that passed the filter.
func filter(callback: Callable) -> GDSet:
	var new_set = GDSet.new()
	for value in self:
		if callback.call(value):
			new_set.add(value)
	return new_set


## Freezes the Set, making it read-only. No modifications will be allowed after freezing.
func freeze() -> void:
	_read_only = true


## Checks if the Set is frozen (read-only).
##
## @return: `true` if the Set is read-only, `false` otherwise.
func is_read_only() -> bool:
	return _read_only


## Returns a new GDSet instance that is a read-only copy of this Set.
##
## @return: A new read-only GDSet.
func get_read_only_view() -> GDSet:
	var view = clone()
	view.freeze()
	return view


## Checks if this Set is a subset of `other_set`.
## A set is a subset of another if all its elements are contained within the other set.
##
## @param other_set: The other GDSet to check against.
## @return: `true` if this Set is a subset, `false` otherwise.
func is_subset_of(other_set: GDSet) -> bool:
	# A set can't be a subset of a smaller set.
	if self.size() > other_set.size():
		return false
	for value in self:
		if not other_set.contains(value):
			return false
	return true


## Checks if this Set is a superset of `other_set`.
## A set is a superset of another if it contains all elements of the other set.
##
## @param other_set: The other GDSet to check against.
## @return: `true` if this Set is a superset, `false` otherwise.
func is_superset_of(other_set: GDSet) -> bool:
	return other_set.is_subset_of(self)


## Initializes the iterator for the Set.
## This is called automatically at the start of a `for` loop.
## This index-based approach is O(n), making loops significantly more performant.
##
## @param _arg: The argument passed to the iterator (unused).
## @return: `true` if the iterator was successfully initialized.
func _iter_init(_arg) -> bool:
	_keys_for_iterator = _data.keys()
	_iterator_index = -1
	return true


## Advances the iterator to the next element.
## This is called automatically during a `for` loop.
##
## @param _arg: The argument passed to the iterator (unused).
## @return: `true` if there is a next element, `false` otherwise.
func _iter_next(_arg) -> bool:
	_iterator_index += 1
	return _iterator_index < _keys_for_iterator.size()


## Gets the current value of the element in the iteration.
## This is called automatically during a `for` loop.
##
## @param _arg: The argument passed to the iterator (unused).
## @return: The current element.
func _iter_get(_arg) -> Variant:
	return _keys_for_iterator[_iterator_index]
