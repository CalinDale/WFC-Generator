class_name ImageReader
extends Node
## Slices a sample image into a collection of patterns.

signal sample_read(sample_map, size, tiles)

const BLANK_PIXEL_ID := -1

export var input_image : Image
export var pattern_size : Vector2

var _sample_image : Image
var _sample_map := {}
var _sample_size : Vector2
var _tiles := {}


func _ready() -> void:
	_read_sample()


func _read_sample() -> void:
	var tiles := []
	var wrap_size := Vector2(pattern_size.x - 1,pattern_size.y - 1)
	var full_size := Vector2(_sample_size.x + wrap_size.x, _sample_size.y + wrap_size.y)
	var map := _convert_to_map()
	_add_wrapped_tiles()
	_print_map()
	emit_signal("sample_read", _sample_map, full_size, tiles)


func _print_map() -> void:
	for x in range(0, _sample_size.x+pattern_size.x-1):
		var line := ""
		for y in range(0, _sample_size.y+pattern_size.y-1):
			var coords = Vector2(x,y)
			line += str(_sample_map.get(coords, 8))
		print(line)


func _convert_to_map() -> Dictionary:
	var map: Dictionary
	var new_id := 0
	_sample_size = input_image.get_size()
	_sample_image = input_image.duplicate()
	_sample_image.lock()
	for x in _sample_size.x:
		for y in _sample_size.y:
			var tile_id : int
			var pixel_coords := Vector2(x,y)
			var pixel_color := _sample_image.get_pixelv(pixel_coords)
			if pixel_color in _tiles:
				tile_id = _tiles.get(pixel_color)
			else:
				tile_id = new_id
				new_id += 1
				_tiles[pixel_color] = tile_id
			map[pixel_coords] = tile_id


func _add_wrapped_tiles() -> void:
	for x_offset in range(0, pattern_size.x-1):
		for y in range (0, _sample_size.y):
			var destination := Vector2(_sample_size.x + x_offset, y)
			var origin := Vector2(0 + x_offset, y)
			_sample_map[destination] = _sample_map[origin]
		for y_offset in range (0, pattern_size.y-1):
			var destination := Vector2(_sample_size.x + x_offset, _sample_size.y + y_offset)
			var origin := Vector2(0 + x_offset, 0 + y_offset)
			_sample_map[destination] = _sample_map[origin]
	for y_offset in range(0, pattern_size.y-1):
		for x in range (0, _sample_size.x):
			var destination := Vector2(x, _sample_size.y + y_offset)
			var origin := Vector2(x, 0 + y_offset)
			_sample_map[destination] = _sample_map[origin]
