## Stores info of a Wave function collapse map and what tiles it uses.
class_name WFCMap
extends Resource

export var data : Dictionary
export var size : Vector2
export var tiles : Array

func _init(p_data := {}, p_size := Vector2.ZERO, p_tiles := []) -> void:
	data = p_data
	size = p_size
	tiles = p_tiles
