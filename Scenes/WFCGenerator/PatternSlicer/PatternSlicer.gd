## Slices unqiue patterns from a WFCMap
class_name PatternSlicer
extends Node

export var should_prefer_common := true
export var can_rotate := true
export var can_mirror_h := true
export var can_mirror_v := true

func generate_patterns(sample_map: WFCMap, pattern_size: Vector2) -> Dictionary:
	var slicable_map := _add_wrapped_tiles(sample_map, pattern_size)

	var patterns := {}
	
	for map_x in sample_map.size.x:
		for map_y in sample_map.size.y:
			var sample_coord = Vector2(map_x, map_y)
			var pattern_map := _slice_pattern(slicable_map, sample_coord, pattern_size)
			var pattern := Pattern.new()
			pattern._init(pattern_map, pattern_size, 1, can_rotate, can_mirror_h, can_mirror_v)
			patterns = _add_if_new(pattern, patterns)
	return patterns


func _add_wrapped_tiles(map: WFCMap, pattern_size: Vector2) -> Dictionary:
	var slicable_map = map.duplicate()
	
	for x_offset in pattern_size.x:
		for y in slicable_map.size.y:
			var destination := Vector2(slicable_map.size.x + x_offset, y)
			var origin := Vector2(0 + x_offset, y)
			slicable_map.data[destination] = slicable_map.data[origin]
			
		for y_offset in pattern_size.y:
			var destination := Vector2(slicable_map.size.x + x_offset, slicable_map.size.y + y_offset)
			var origin := Vector2(0 + x_offset, 0 + y_offset)
			slicable_map.data[destination] = slicable_map.data[origin]
			
	for y_offset in pattern_size.y:
		for x in slicable_map.size.x:
			var destination := Vector2(x, slicable_map.size.y + y_offset)
			var origin := Vector2(x, 0 + y_offset)
			slicable_map.data[destination] = slicable_map.data[origin]
			
	return slicable_map.data


func _slice_pattern(map: Dictionary, map_coord: Vector2, pattern_size: Vector2) -> Dictionary:
	var pattern_map := {}
	for x in pattern_size.x:
		for y in pattern_size.y:
			var pattern_tile_coord := Vector2(x, y)
			var map_tile_coord := map_coord + pattern_tile_coord
			pattern_map[pattern_tile_coord] = map[map_tile_coord]
	return pattern_map


func _add_if_new(new_pattern: Pattern, patterns: Dictionary) -> Dictionary:
	var pattern_string := new_pattern.to_string()
	if pattern_string in patterns:
		if should_prefer_common:
			patterns[pattern_string].commonality += 1
	else:
		patterns[pattern_string] = new_pattern
	return patterns
