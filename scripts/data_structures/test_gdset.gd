# test_gdset.gd
extends Node

## A simple assertion function for testing.
func assert_true(condition: bool, message: String):
	if not condition:
		push_error("ASSERTION FAILED: " + message)
		get_tree().quit() # Optionally quit on failure for CI/CD or immediate feedback
	else:
		print("ASSERTION PASSED: " + message)

## Setup for tests
func _ready():
	print("--- Running GDSet Tests ---")
	test_constructor_and_add()
	test_add_all()
	test_contains_and_has()
	test_remove()
	test_size()
	test_clear()
	test_to_array_and_to_dictionary()
	test_clone()
	test_equals()
	test_union()
	test_intersection()
	test_difference()
	test_xor()
	test_map()
	test_filter()
	test_freeze_and_read_only()
	test_is_subset_of_and_is_superset_of()
	test_iterator()
	test_signals()
	print("--- All GDSet Tests Completed ---")

## Test cases for constructor and add method
func test_constructor_and_add():
	print("\n## Testing Constructor and Add ##")

	# Test 1: Empty constructor
	var set1 = GDSet.new()
	assert_true(set1.size() == 0, "Test 1.1: New empty set should have size 0.")

	# Test 2: Constructor with initial array
	var set2 = GDSet.new([1, 2, 3])
	assert_true(set2.size() == 3, "Test 2.1: Set initialized with [1, 2, 3] should have size 3.")
	assert_true(set2.contains(1) and set2.contains(2) and set2.contains(3), "Test 2.2: Set should contain all initial elements.")

	# Test 3: Constructor with duplicates in initial array
	var set3 = GDSet.new([1, 1, 2, 3, 2])
	assert_true(set3.size() == 3, "Test 3.1: Set initialized with duplicates should handle them correctly.")
	assert_true(set3.contains(1) and set3.contains(2) and set3.contains(3), "Test 3.2: Set should contain unique elements from initial array.")

	# Test 4: Add single element
	set1.add(5)
	assert_true(set1.size() == 1, "Test 4.1: After adding 5, set size should be 1.")
	assert_true(set1.contains(5), "Test 4.2: Set should contain 5 after adding.")

	# Test 5: Add existing element (should not change size)
	set1.add(5)
	assert_true(set1.size() == 1, "Test 5.1: Adding existing element should not change size.")

	# Test 6: Add different types
	var set4 = GDSet.new()
	set4.add("hello")
	set4.add(123)
	set4.add(true)
	assert_true(set4.size() == 3, "Test 6.1: Set should handle different data types.")
	assert_true(set4.contains("hello") and set4.contains(123) and set4.contains(true), "Test 6.2: Set should contain mixed types.")

	# Test 7: Add null
	var set5 = GDSet.new()
	set5.add(null)
	assert_true(set5.size() == 1, "Test 7.1: Set should allow adding null.")
	assert_true(set5.contains(null), "Test 7.2: Set should contain null.")

## Test cases for add_all method
func test_add_all():
	print("\n## Testing Add All ##")

	var set = GDSet.new()

	# Test 1: Add all from an empty array
	set.add_all([])
	assert_true(set.size() == 0, "Test 1.1: Adding from empty array should result in empty set.")

	# Test 2: Add all from a non-empty array
	set.add_all([10, 20, 30])
	assert_true(set.size() == 3, "Test 2.1: Set should have 3 elements after adding [10, 20, 30].")
	assert_true(set.contains(10) and set.contains(20) and set.contains(30), "Test 2.2: Set should contain all added elements.")

	# Test 3: Add all with duplicates
	set.add_all([20, 40, 50, 40])
	assert_true(set.size() == 5, "Test 3.1: Adding duplicates via add_all should only add unique new elements.")
	assert_true(set.contains(10) and set.contains(20) and set.contains(30) and set.contains(40) and set.contains(50), "Test 3.2: Set should contain all unique elements after add_all with duplicates.")

## Test cases for contains and _has methods
func test_contains_and_has():
	print("\n## Testing Contains and _has ##")

	var set = GDSet.new([1, 2, "three", null])

	# Test 1: Check existing elements
	assert_true(set.contains(1), "Test 1.1: Set should contain 1.")
	assert_true(set._has(2), "Test 1.2: Set should contain 2 using _has.")
	assert_true(set.contains("three"), "Test 1.3: Set should contain 'three'.")
	assert_true(set.contains(null), "Test 1.4: Set should contain null.")

	# Test 2: Check non-existing elements
	assert_true(not set.contains(4), "Test 2.1: Set should not contain 4.")
	assert_true(not set._has("four"), "Test 2.2: Set should not contain 'four' using _has.")
	assert_true(not set.contains(false), "Test 2.3: Set should not contain false.")

## Test cases for remove method
func test_remove():
	print("\n## Testing Remove ##")

	var set = GDSet.new([1, 2, 3, 4])

	# Test 1: Remove existing element
	set.remove(2)
	assert_true(set.size() == 3, "Test 1.1: Size should be 3 after removing 2.")
	assert_true(not set.contains(2), "Test 1.2: Set should no longer contain 2.")
	assert_true(set.contains(1) and set.contains(3) and set.contains(4), "Test 1.3: Other elements should remain.")

	# Test 2: Remove non-existing element (should not change size)
	set.remove(5)
	assert_true(set.size() == 3, "Test 2.1: Removing non-existing element should not change size.")

	# Test 3: Remove all elements
	set.remove(1)
	set.remove(3)
	set.remove(4)
	assert_true(set.size() == 0, "Test 3.1: Set should be empty after removing all elements.")

	# Test 4: Remove from an empty set
	set.remove(10)
	assert_true(set.size() == 0, "Test 4.1: Removing from an empty set should not cause errors.")

## Test cases for size method
func test_size():
	print("\n## Testing Size ##")

	var set1 = GDSet.new()
	assert_true(set1.size() == 0, "Test 1.1: Empty set size should be 0.")

	var set2 = GDSet.new([1, 2, 3])
	assert_true(set2.size() == 3, "Test 2.1: Set with 3 elements size should be 3.")

	set2.add(4)
	assert_true(set2.size() == 4, "Test 3.1: Size should increment after add.")

	set2.remove(1)
	assert_true(set2.size() == 3, "Test 4.1: Size should decrement after remove.")

	set2.add(4) # Adding existing
	assert_true(set2.size() == 3, "Test 5.1: Adding existing element should not change size.")

## Test cases for clear method
func test_clear():
	print("\n## Testing Clear ##")

	var set = GDSet.new([1, 2, 3, "test"])

	# Test 1: Clear a non-empty set
	set.clear()
	assert_true(set.size() == 0, "Test 1.1: Set should be empty after clear.")

	# Test 2: Clear an already empty set
	set.clear()
	assert_true(set.size() == 0, "Test 2.1: Clearing an empty set should still result in empty set.")

## Test cases for to_array and to_dictionary methods
func test_to_array_and_to_dictionary():
	print("\n## Testing to_array and to_dictionary ##")

	var set = GDSet.new(["a", "b", 1, 2])

	# Test 1: to_array
	var arr = set.to_array()
	assert_true(arr.size() == 4, "Test 1.1: to_array should return an array with correct size.")
	assert_true(arr.has("a") and arr.has("b") and arr.has(1) and arr.has(2), "Test 1.2: to_array should contain all elements.")

	# Test 2: to_dictionary
	var dict = set.to_dictionary()
	assert_true(dict.size() == 4, "Test 2.1: to_dictionary should return a dictionary with correct size.")
	assert_true(dict.has("a") and dict["a"] == true, "Test 2.2: Dictionary should have 'a' as key with value true.")
	assert_true(dict.has(1) and dict[1] == true, "Test 2.3: Dictionary should have 1 as key with value true.")

	# Test 3: Modifying the returned dictionary should not affect the set
	dict["c"] = true
	assert_true(not set.contains("c"), "Test 3.1: Modifying returned dictionary should not affect the original set.")

## Test cases for clone method
func test_clone():
	print("\n## Testing Clone ##")

	var set1 = GDSet.new([1, 2, 3])
	var set2 = set1.clone()

	# Test 1: Cloned set should have same elements and size
	assert_true(set2.size() == 3, "Test 1.1: Cloned set should have the same size.")
	assert_true(set2.contains(1) and set2.contains(2) and set2.contains(3), "Test 1.2: Cloned set should contain all elements of original.")

	# Test 2: Modifying clone should not affect original
	set2.add(4)
	assert_true(set2.size() == 4, "Test 2.1: Cloned set size should change after add.")
	assert_true(not set1.contains(4), "Test 2.2: Original set should not contain new element added to clone.")
	assert_true(set1.size() == 3, "Test 2.3: Original set size should remain unchanged.")

	set2.remove(1)
	assert_true(not set2.contains(1), "Test 2.4: Element removed from clone should be gone from clone.")
	assert_true(set1.contains(1), "Test 2.5: Element removed from clone should still exist in original.")

	# Test 3: Cloned set's read-only status should be copied
	set1.freeze()
	var set3 = set1.clone()
	assert_true(set3.is_read_only(), "Test 3.1: Cloned set should inherit read-only status.")

## Test cases for equals method
func test_equals():
	print("\n## Testing Equals ##")

	var set1 = GDSet.new([1, 2, 3])
	var set2 = GDSet.new([3, 1, 2]) # Same elements, different order
	var set3 = GDSet.new([1, 2, 3, 4]) # Superset
	var set4 = GDSet.new([1, 2]) # Subset
	var set5 = GDSet.new([1, 5, 6]) # Different elements
	var set6 = GDSet.new()

	# Test 1: Equal sets
	assert_true(set1.equals(set2), "Test 1.1: Sets with same elements (different order) should be equal.")
	assert_true(set2.equals(set1), "Test 1.2: Equality should be symmetric.")

	# Test 2: Unequal sets (different size)
	assert_true(not set1.equals(set3), "Test 2.1: Unequal sets (superset) should not be equal.")
	assert_true(not set1.equals(set4), "Test 2.2: Unequal sets (subset) should not be equal.")

	# Test 3: Unequal sets (different elements)
	assert_true(not set1.equals(set5), "Test 3.1: Sets with different elements should not be equal.")

	# Test 4: Comparison with empty set
	var empty_set1 = GDSet.new()
	var empty_set2 = GDSet.new()
	assert_true(empty_set1.equals(empty_set2), "Test 4.1: Two empty sets should be equal.")
	assert_true(not set1.equals(empty_set1), "Test 4.2: Non-empty set should not be equal to empty set.")

## Test cases for union method
func test_union():
	print("\n## Testing Union ##")

	var set1 = GDSet.new([1, 2, 3])
	var set2 = GDSet.new([3, 4, 5])
	var set_empty = GDSet.new()
	var set_all = GDSet.new([1, 2, 3, 4, 5, 6])

	# Test 1: Standard union
	var union_set1 = set1.union(set2)
	assert_true(union_set1.size() == 5, "Test 1.1: Union of [1,2,3] and [3,4,5] should have size 5.")
	assert_true(union_set1.contains(1) and union_set1.contains(2) and union_set1.contains(3) and union_set1.contains(4) and union_set1.contains(5), "Test 1.2: Union set should contain 1,2,3,4,5.")

	# Test 2: Union with empty set
	var union_set2 = set1.union(set_empty)
	assert_true(set1.equals(union_set2), "Test 2.1: Union with empty set should be the original set.")
	var union_set3 = set_empty.union(set1)
	assert_true(set1.equals(union_set3), "Test 2.2: Union (empty first) with non-empty set should be the non-empty set.")

	# Test 3: Union of two empty sets
	var union_set4 = set_empty.union(GDSet.new())
	assert_true(union_set4.size() == 0, "Test 3.1: Union of two empty sets should be empty.")

	# Test 4: Union with self
	var union_set5 = set1.union(set1)
	assert_true(set1.equals(union_set5), "Test 4.1: Union with self should be the original set.")

	# Test 5: Union with an all-encompassing set
	var union_set6 = set1.union(set_all)
	assert_true(set_all.equals(union_set6), "Test 5.1: Union with a superset should result in the superset.")

## Test cases for intersection method
func test_intersection():
	print("\n## Testing Intersection ##")

	var set1 = GDSet.new([1, 2, 3, 4])
	var set2 = GDSet.new([3, 4, 5, 6])
	var set3 = GDSet.new([7, 8])
	var set_empty = GDSet.new()

	# Test 1: Standard intersection
	var intersection_set1 = set1.intersection(set2)
	assert_true(intersection_set1.size() == 2, "Test 1.1: Intersection of [1,2,3,4] and [3,4,5,6] should have size 2.")
	assert_true(intersection_set1.contains(3) and intersection_set1.contains(4), "Test 1.2: Intersection set should contain 3,4.")

	# Test 2: Intersection with no common elements
	var intersection_set2 = set1.intersection(set3)
	assert_true(intersection_set2.size() == 0, "Test 2.1: Intersection with no common elements should be empty.")

	# Test 3: Intersection with empty set
	var intersection_set3 = set1.intersection(set_empty)
	assert_true(intersection_set3.size() == 0, "Test 3.1: Intersection with empty set should be empty.")
	var intersection_set4 = set_empty.intersection(set1)
	assert_true(intersection_set4.size() == 0, "Test 3.2: Intersection (empty first) with non-empty set should be empty.")

	# Test 4: Intersection with self
	var intersection_set5 = set1.intersection(set1)
	assert_true(set1.equals(intersection_set5), "Test 4.1: Intersection with self should be the original set.")

	# Test 5: Intersection where one is a subset of the other
	var set4 = GDSet.new([1, 2])
	var intersection_set6 = set1.intersection(set4)
	assert_true(set4.equals(intersection_set6), "Test 5.1: Intersection where one is subset should be the subset.")

## Test cases for difference method
func test_difference():
	print("\n## Testing Difference ##")

	var set1 = GDSet.new([1, 2, 3, 4])
	var set2 = GDSet.new([3, 4, 5, 6])
	var set_empty = GDSet.new()

	# Test 1: Standard difference (set1 - set2)
	var diff_set1 = set1.difference(set2)
	assert_true(diff_set1.size() == 2, "Test 1.1: Difference of [1,2,3,4] - [3,4,5,6] should have size 2.")
	assert_true(diff_set1.contains(1) and diff_set1.contains(2), "Test 1.2: Difference set should contain 1,2.")

	# Test 2: Standard difference (set2 - set1)
	var diff_set2 = set2.difference(set1)
	assert_true(diff_set2.size() == 2, "Test 2.1: Difference of [3,4,5,6] - [1,2,3,4] should have size 2.")
	assert_true(diff_set2.contains(5) and diff_set2.contains(6), "Test 2.2: Difference set should contain 5,6.")

	# Test 3: Difference with empty set
	var diff_set3 = set1.difference(set_empty)
	assert_true(set1.equals(diff_set3), "Test 3.1: Difference with empty set should be the original set.")

	# Test 4: Empty set difference with non-empty set
	var diff_set4 = set_empty.difference(set1)
	assert_true(diff_set4.size() == 0, "Test 4.1: Empty set difference with non-empty set should be empty.")

	# Test 5: Difference with self (should be empty)
	var diff_set5 = set1.difference(set1)
	assert_true(diff_set5.size() == 0, "Test 5.1: Difference with self should be empty.")

	# Test 6: One set is a subset of the other
	var set_subset = GDSet.new([1, 2])
	var diff_set6 = set1.difference(set_subset)
	assert_true(diff_set6.size() == 2, "Test 6.1: Difference of superset - subset should have remaining elements.")
	assert_true(diff_set6.contains(3) and diff_set6.contains(4), "Test 6.2: Difference set should contain 3,4.")
	var diff_set7 = set_subset.difference(set1)
	assert_true(diff_set7.size() == 0, "Test 6.3: Difference of subset - superset should be empty.")

## Test cases for xor (symmetric difference) method
func test_xor():
	print("\n## Testing XOR (Symmetric Difference) ##")

	var set1 = GDSet.new([1, 2, 3, 4])
	var set2 = GDSet.new([3, 4, 5, 6])
	var set_empty = GDSet.new()

	# Test 1: Standard XOR
	var xor_set1 = set1.xor(set2)
	assert_true(xor_set1.size() == 4, "Test 1.1: XOR of [1,2,3,4] and [3,4,5,6] should have size 4.")
	assert_true(xor_set1.contains(1) and xor_set1.contains(2) and xor_set1.contains(5) and xor_set1.contains(6), "Test 1.2: XOR set should contain 1,2,5,6.")

	# Test 2: XOR with empty set
	var xor_set2 = set1.xor(set_empty)
	assert_true(set1.equals(xor_set2), "Test 2.1: XOR with empty set should be the original set.")

	# Test 3: XOR with self (should be empty)
	var xor_set3 = set1.xor(set1)
	assert_true(xor_set3.size() == 0, "Test 3.1: XOR with self should be empty.")

	# Test 4: XOR of two empty sets
	var xor_set4 = set_empty.xor(GDSet.new())
	assert_true(xor_set4.size() == 0, "Test 4.1: XOR of two empty sets should be empty.")

	# Test 5: XOR where one is a subset of the other
	var set_subset = GDSet.new([1, 2])
	var xor_set5 = set1.xor(set_subset)
	assert_true(xor_set5.size() == 2, "Test 5.1: XOR of superset and subset should be the difference of superset - subset.")
	assert_true(xor_set5.contains(3) and xor_set5.contains(4), "Test 5.2: XOR set should contain 3,4.")

## Test cases for map method
func test_map():
	print("\n## Testing Map ##")

	var set = GDSet.new([1, 2, 3])

	# Test 1: Map with a simple transformation (double each number)
	var mapped_set1 = set.map(Callable(self, "_double_number"))
	assert_true(mapped_set1.size() == 3, "Test 1.1: Mapped set should have the same size.")
	assert_true(mapped_set1.contains(2) and mapped_set1.contains(4) and mapped_set1.contains(6), "Test 1.2: Mapped set should contain doubled values.")
	assert_true(not mapped_set1.contains(1), "Test 1.3: Mapped set should not contain original values.")

	# Test 2: Map to a different type (number to string)
	var mapped_set2 = set.map(Callable(self, "_to_string"))
	assert_true(mapped_set2.size() == 3, "Test 2.1: Mapped set (to string) should have same size.")
	assert_true(mapped_set2.contains("1") and mapped_set2.contains("2") and mapped_set2.contains("3"), "Test 2.2: Mapped set should contain string values.")

	# Test 3: Map on an empty set
	var empty_set = GDSet.new()
	var mapped_empty_set = empty_set.map(Callable(self, "_double_number"))
	assert_true(mapped_empty_set.size() == 0, "Test 3.1: Mapping an empty set should result in an empty set.")

	# Test 4: Map that produces duplicates (should still be a set)
	var set_with_duplicates_after_map = GDSet.new([1, -1, 2, -2])
	var mapped_set_duplicates = set_with_duplicates_after_map.map(Callable(self, "_abs_value"))
	assert_true(mapped_set_duplicates.size() == 2, "Test 4.1: Map producing duplicates should result in a set with unique values.")
	assert_true(mapped_set_duplicates.contains(1) and mapped_set_duplicates.contains(2), "Test 4.2: Mapped set should contain absolute unique values.")

func _double_number(value):
	return value * 2

func _abs_value(value):
	return abs(value)

## Test cases for filter method
func test_filter():
	print("\n## Testing Filter ##")

	var set = GDSet.new([1, 2, 3, 4, 5, 6])

	# Test 1: Filter for even numbers
	var filtered_set1 = set.filter(Callable(self, "_is_even"))
	assert_true(filtered_set1.size() == 3, "Test 1.1: Filtered set for even numbers should have size 3.")
	assert_true(filtered_set1.contains(2) and filtered_set1.contains(4) and filtered_set1.contains(6), "Test 1.2: Filtered set should contain 2,4,6.")

	# Test 2: Filter for numbers greater than 3
	var filtered_set2 = set.filter(Callable(self, "_is_greater_than_3"))
	assert_true(filtered_set2.size() == 3, "Test 2.1: Filtered set for >3 should have size 3.")
	assert_true(filtered_set2.contains(4) and filtered_set2.contains(5) and filtered_set2.contains(6), "Test 2.2: Filtered set should contain 4,5,6.")

	# Test 3: Filter that results in an empty set
	var filtered_set3 = set.filter(Callable(self, "_is_negative"))
	assert_true(filtered_set3.size() == 0, "Test 3.1: Filter resulting in no matches should be empty.")

	# Test 4: Filter on an empty set
	var empty_set = GDSet.new()
	var filtered_empty_set = empty_set.filter(Callable(self, "_is_even"))
	assert_true(filtered_empty_set.size() == 0, "Test 4.1: Filtering an empty set should result in an empty set.")

	# Test 5: Filter that returns all elements
	var filtered_set4 = set.filter(Callable(self, "_return_true"))
	assert_true(set.equals(filtered_set4), "Test 5.1: Filter always returning true should result in an equal set.")

func _is_even(value):
	return value % 2 == 0

func _is_greater_than_3(value):
	return value > 3

func _is_negative(value):
	return value < 0

func _return_true(value):
	return true

## Test cases for freeze and read-only functionality
func test_freeze_and_read_only():
	print("\n## Testing Freeze and Read-Only ##")

	var set = GDSet.new([1, 2, 3])

	# Test 1: Initial state should not be read-only
	assert_true(not set.is_read_only(), "Test 1.1: New set should not be read-only by default.")

	# Test 2: Freeze the set
	set.freeze()
	assert_true(set.is_read_only(), "Test 2.1: After freeze(), set should be read-only.")

	# Test 3: Attempt to add to a frozen set (should emit error and not modify)
	set.add(4)
	assert_true(not set.contains(4), "Test 3.1: Cannot add to a frozen set.")
	assert_true(set.size() == 3, "Test 3.2: Size of frozen set should not change after attempted add.")

	# Test 4: Attempt to add_all to a frozen set
	set.add_all([5, 6])
	assert_true(not set.contains(5) and not set.contains(6), "Test 4.1: Cannot add_all to a frozen set.")
	assert_true(set.size() == 3, "Test 4.2: Size of frozen set should not change after attempted add_all.")

	# Test 5: Attempt to remove from a frozen set
	set.remove(1)
	assert_true(set.contains(1), "Test 5.1: Cannot remove from a frozen set.")
	assert_true(set.size() == 3, "Test 5.2: Size of frozen set should not change after attempted remove.")

	# Test 6: Attempt to clear a frozen set
	set.clear()
	assert_true(set.size() == 3, "Test 6.1: Cannot clear a frozen set.")
	assert_true(set.contains(1) and set.contains(2) and set.contains(3), "Test 6.2: Frozen set should not be cleared.")

	# Test 7: get_read_only_view
	var original_set = GDSet.new([10, 20, 30])
	var read_only_view = original_set.get_read_only_view()
	assert_true(read_only_view.is_read_only(), "Test 7.1: View obtained from get_read_only_view should be read-only.")
	assert_true(read_only_view.equals(original_set), "Test 7.2: Read-only view should contain same elements as original.")
	original_set.add(40)
	assert_true(read_only_view.size() == 3, "Test 7.3: Modifying original set should not affect read-only view.")
	read_only_view.add(50) # Should error and not modify
	assert_true(not read_only_view.contains(50), "Test 7.4: Read-only view cannot be modified.")

## Test cases for is_subset_of and is_superset_of
func test_is_subset_of_and_is_superset_of():
	print("\n## Testing Subset and Superset ##")

	var set1 = GDSet.new([1, 2, 3])
	var set2 = GDSet.new([1, 2, 3, 4, 5])
	var set3 = GDSet.new([1, 2])
	var set4 = GDSet.new([4, 5])
	var set_empty = GDSet.new()

	# Test 1: Is subset
	assert_true(set1.is_subset_of(set2), "Test 1.1: [1,2,3] is subset of [1,2,3,4,5].")
	assert_true(set3.is_subset_of(set1), "Test 1.2: [1,2] is subset of [1,2,3].")
	assert_true(set1.is_subset_of(set1), "Test 1.3: Set is subset of itself.")
	assert_true(set_empty.is_subset_of(set1), "Test 1.4: Empty set is subset of any set.")
	assert_true(set_empty.is_subset_of(set_empty), "Test 1.5: Empty set is subset of empty set.")

	# Test 2: Is NOT subset
	assert_true(not set2.is_subset_of(set1), "Test 2.1: [1,2,3,4,5] is NOT subset of [1,2,3].")
	assert_true(not set1.is_subset_of(set4), "Test 2.2: [1,2,3] is NOT subset of [4,5].")

	# Test 3: Is superset
	assert_true(set2.is_superset_of(set1), "Test 3.1: [1,2,3,4,5] is superset of [1,2,3].")
	assert_true(set1.is_superset_of(set3), "Test 3.2: [1,2,3] is superset of [1,2].")
	assert_true(set1.is_superset_of(set1), "Test 3.3: Set is superset of itself.")
	assert_true(set1.is_superset_of(set_empty), "Test 3.4: Any set is superset of empty set.")
	assert_true(set_empty.is_superset_of(set_empty), "Test 3.5: Empty set is superset of empty set.")

	# Test 4: Is NOT superset
	assert_true(not set1.is_superset_of(set2), "Test 4.1: [1,2,3] is NOT superset of [1,2,3,4,5].")
	assert_true(not set1.is_superset_of(set4), "Test 4.2: [1,2,3] is NOT superset of [4,5].")

## Test cases for iterator functionality (for-in loop)
func test_iterator():
	print("\n## Testing Iterator ##")

	var set = GDSet.new(["apple", "banana", "cherry"])
	var elements_found = GDSet.new()
	var count = 0

	# Test 1: Iterate over a non-empty set
	for element in set:
		elements_found.add(element)
		count += 1

	assert_true(count == 3, "Test 1.1: Iterator should visit all 3 elements.")
	assert_true(elements_found.contains("apple") and elements_found.contains("banana") and elements_found.contains("cherry"), "Test 1.2: Iterator should retrieve all original elements.")
	assert_true(elements_found.equals(set), "Test 1.3: Set of found elements should be equal to original set.")

	# Test 2: Iterate over an empty set
	var empty_set = GDSet.new()
	var empty_count = 0
	for element in empty_set:
		empty_count += 1
	assert_true(empty_count == 0, "Test 2.1: Iterating over an empty set should not run the loop body.")

	# Test 3: Iteration after modifications (should use new snapshot)
	var mod_set = GDSet.new([1, 2])
	var iterated_elements_after_add = GDSet.new()
	mod_set.add(3) # Modify before iteration starts
	for element in mod_set:
		iterated_elements_after_add.add(element)
	assert_true(iterated_elements_after_add.size() == 3, "Test 3.1: Iterator should reflect additions before loop starts.")
	assert_true(iterated_elements_after_add.contains(1) and iterated_elements_after_add.contains(2) and iterated_elements_after_add.contains(3), "Test 3.2: Iterator should include newly added elements.")

	mod_set.remove(1)
	var iterated_elements_after_remove = GDSet.new()
	for element in mod_set:
		iterated_elements_after_remove.add(element)
	assert_true(iterated_elements_after_remove.size() == 2, "Test 3.3: Iterator should reflect removals before loop starts.")
	assert_true(not iterated_elements_after_remove.contains(1), "Test 3.4: Iterator should not include removed elements.")
	assert_true(iterated_elements_after_remove.contains(2) and iterated_elements_after_remove.contains(3), "Test 3.5: Iterator should include remaining elements.")

## Test cases for signals
func test_signals():
	print("\n## Testing Signals ##")

	var set = GDSet.new()
	var added_elements = []
	var removed_elements = []

	# Connect signals
	set.connect("element_added", Callable(self, "_on_element_added"))
	set.connect("element_removed", Callable(self, "_on_element_removed"))

	# Test 1: add() should emit element_added
	set.add(10)
	assert_true(added_elements.size() == 1, "Test 1.1: element_added signal should be emitted once for add(10).")
	assert_true(added_elements[0] == 10, "Test 1.2: Added element value should be 10.")
	added_elements.clear()

	# Test 2: add() with existing element should not emit
	set.add(10)
	assert_true(added_elements.empty(), "Test 2.1: Adding existing element should not emit element_added.")

	# Test 3: add_all() should emit for new elements
	set.add_all([20, 30, 10, 40])
	assert_true(added_elements.size() == 3, "Test 3.1: add_all should emit for 20, 30, 40.")
	assert_true(added_elements.has(20) and added_elements.has(30) and added_elements.has(40), "Test 3.2: Added elements from add_all should be 20, 30, 40.")
	added_elements.clear()

	# Test 4: remove() should emit element_removed
	set.remove(20)
	assert_true(removed_elements.size() == 1, "Test 4.1: element_removed signal should be emitted once for remove(20).")
	assert_true(removed_elements[0] == 20, "Test 4.2: Removed element value should be 20.")
	removed_elements.clear()

	# Test 5: remove() with non-existing element should not emit
	set.remove(50)
	assert_true(removed_elements.empty(), "Test 5.1: Removing non-existing element should not emit element_removed.")

	# Test 6: clear() should emit for each removed element
	set.clear()
	assert_true(removed_elements.size() == 3, "Test 6.1: clear() should emit element_removed for each remaining element.")
	assert_true(removed_elements.has(10) and removed_elements.has(30) and removed_elements.has(40), "Test 6.2: Cleared elements should be 10, 30, 40.")
	removed_elements.clear()
