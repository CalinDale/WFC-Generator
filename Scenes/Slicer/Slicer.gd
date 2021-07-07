class_name Slicer
extends Node
## Slices a sample image into a collection of patterns.

const BLANK_PIXEL_ID := -1

export var input_image : Image
export var pattern_size := 3
export var mirror_h := true
export var mirror_v := true
export var rotate := true
export var prefer_common := true
export var maintain_sides_h := false
export var maintain_sides_v := false

var _sample_image : Image
var _sample_map := {}
var _sample_size : Vector2
var _tiles := {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_slice()


func _slice() -> void:
	_convert_to_map()
	_print_map()


func _print_map() -> void:
	for x in range(-1, _sample_size.x+1):
		var line := ""
		for y in range(-1, _sample_size.y+1):
			var coords = Vector2(x,y)
			line += str(_sample_map[coords])
		print(line)


func _convert_to_map() -> void:
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
			_sample_map[pixel_coords] = tile_id
	if maintain_sides_h or maintain_sides_v:
		_add_side_pixels()


func _add_side_pixels() -> void:
		_tiles[Color.transparent] = BLANK_PIXEL_ID
		if maintain_sides_h:
			for y in range(0, _sample_size.y):
				_sample_map[Vector2(-1, y)] = BLANK_PIXEL_ID
				_sample_map[Vector2(_sample_size.x + 1, y)] = BLANK_PIXEL_ID
		if maintain_sides_v:
			for x in range(0, _sample_size.x):
				_sample_map[Vector2(x, -1)] = BLANK_PIXEL_ID
				_sample_map[Vector2(x, _sample_size.y + 1)] = BLANK_PIXEL_ID
		if maintain_sides_h and maintain_sides_v:
			_sample_map[Vector2(-1, -1)] = BLANK_PIXEL_ID
			_sample_map[Vector2(_sample_size.x + 1, _sample_size.y + 1)] = BLANK_PIXEL_ID
