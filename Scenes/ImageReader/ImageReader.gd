class_name ImageReader
extends Node
## Slices a sample image into a collection of patterns.

signal sample_read(sample_map, size, tiles)

export var sample_image : Image
export var pattern_size : Vector2


func _ready() -> void:
	var map := _read_sample_image(sample_image)
	emit_signal("sample_read", map)
	_slice_map(map, pattern_size)


func _read_sample_image(image: Image) -> WFCMap:
	var wrap_size := Vector2(pattern_size.x - 1,pattern_size.y - 1)
	var map := _convert_to_map(image)
	return map


func _print_map(map: WFCMap, pattern_size: Vector2) -> void:
	for x in range(0, map.size.x+pattern_size.x-1):
		var line := ""
		for y in range(0, map.size.y+pattern_size.y-1):
			var coords = Vector2(x,y)
			line += str(map.data.get(coords, "X"))
		print(line)


func _convert_to_map(input_image: Image) -> WFCMap:
	var image := input_image.duplicate()
	image.lock()
	
	var map := WFCMap.new()
	map.size = image.get_size()
	
	var color_ids : Dictionary
	color_ids[Color.transparent] = 0
	map.tiles.append(Color.transparent)
	
	var new_id := 1
	for x in map.size.x:
		for y in map.size.y:
			var tile_id : int
			var tile_coords := Vector2(x,y)
			var tile_color : Color = image.get_pixelv(tile_coords)
			
			if tile_color in color_ids:
				tile_id = color_ids.get(tile_color)
			else:
				tile_id = new_id
				new_id += 1
				color_ids[tile_color] = tile_id
				map.tiles.append(tile_color)
				
			map.data[tile_coords] = tile_id

	return map


func _slice_map(map: WFCMap, pattern_size: Vector2) -> void:
	var slicable_map := _add_wrapped_tiles(map, pattern_size)


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
