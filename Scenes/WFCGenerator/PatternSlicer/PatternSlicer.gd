## Slices patterns from a WFCMap
class_name PatternSlicer
extends Node

export var rotate := true
export var mirror_h := true
export var mirror_v := true
export var prefer_common := true

func generate_patterns(map: WFCMap, pattern_size: Vector2) -> void:
	var slicable_map := _add_wrapped_tiles(map, pattern_size)

	var patterns := {}
	
	for map_x in map.size.x:
		for map_y in map.size.y:
			var map_coord = Vector2(map_x, map_y)
			var pattern := Pattern.new()
			pattern._init({}, pattern_size, rotate, mirror_h, mirror_v)
			pattern._data = _slice_tiles(slicable_map, map_coord, pattern_size)


func _slice_tiles(map: Dictionary, map_coord: Vector2, pattern_size: Vector2) -> Dictionary:
	var tiles := {}
	for x in pattern_size.x:
		for y in pattern_size.y:
			var pattern_tile_coord := Vector2(x, y)
			var map_tile_coord := map_coord + pattern_tile_coord
			tiles[pattern_tile_coord] = map[map_tile_coord]
	return tiles


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
