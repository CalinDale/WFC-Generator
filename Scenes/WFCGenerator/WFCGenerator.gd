## Main script for running the generator
class_name WFCGenerator
extends Node

signal sample_read(map)
signal patterns_sliced(patterns)

export var sample_image : Image
export var pattern_size : Vector2

onready var _image_reader := $ImageReader
onready var _pattern_slicer := $PatternSlicer


func go() -> void:
	var sample_map : WFCMap = _image_reader.convert_to_map(sample_image)
	emit_signal("sample_read", sample_map)
	var patterns : Dictionary = _pattern_slicer.generate_patterns(sample_map, pattern_size)
	emit_signal("patterns_sliced", patterns)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
