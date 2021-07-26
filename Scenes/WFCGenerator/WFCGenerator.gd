## Main script for running the generator
class_name WFCGenerator
extends Node

signal sample_read(map)
signal patterns_sliced(patterns)
signal full_pattern_list_built(full_pattern_list)

export var sample_image : Image
export var pattern_size : Vector2

onready var _image_reader := $ImageReader
onready var _pattern_slicer := $PatternSlicer
onready var _pattern_list_builder := $PatternListBuilder


func go() -> void:
	var sample_map : WFCMap = _image_reader.convert_to_map(sample_image)
	emit_signal("sample_read", sample_map)
	var patterns : Dictionary = _pattern_slicer.generate_patterns(sample_map, pattern_size)
	emit_signal("patterns_sliced", patterns)
	var full_pattern_list : Dictionary = _pattern_list_builder.build_full_pattern_list(patterns)
	emit_signal("full_pattern_list_built", full_pattern_list)
	var pattern_lottery : Array = _pattern_list_builder.build_pattern_lottery(full_pattern_list)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
