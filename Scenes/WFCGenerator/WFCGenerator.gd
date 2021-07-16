## Main script for running the generator
class_name WFCGenerator
extends Node

signal sample_read(map)

export var sample_image : Image

onready var _image_reader := $ImageReader


func go() -> void:
	var sample_map : WFCMap = _image_reader.convert_to_map(sample_image)
	emit_signal("sample_read", sample_map)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
