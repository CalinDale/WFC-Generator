## Slices patterns from a WFCMap
class_name Slicer
extends Node

func _add_wrapped_tiles(map, pattern_size) -> WFCMap:
	var slicable_map = map.duplicate()
	
	for x_offset in range(0, pattern_size.x-1):
		for y in range (0, slicable_map.size.y):
			var destination := Vector2(slicable_map.size.x + x_offset, y)
			var origin := Vector2(0 + x_offset, y)
			slicable_map.data[destination] = slicable_map.data[origin]
		for y_offset in range (0, pattern_size.y-1):
			var destination := Vector2(slicable_map.size.x + x_offset, slicable_map.size.y + y_offset)
			var origin := Vector2(0 + x_offset, 0 + y_offset)
			slicable_map.data[destination] = slicable_map.data[origin]
	for y_offset in range(0, pattern_size.y-1):
		for x in range (0, slicable_map.size.x):
			var destination := Vector2(x, slicable_map.size.y + y_offset)
			var origin := Vector2(x, 0 + y_offset)
			slicable_map.data[destination] = slicable_map.data[origin]
	return slicable_map
