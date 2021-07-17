## Stores a pattern placed when generating WFC maps
class_name Pattern
extends Resource


export var data: Dictionary setget set_data, get_data
export var size: Vector2
export var commonality: int
export var rotatable: bool
export var mirrorable_h: bool
export var mirrorable_v: bool

var _variations := []
var _string := ""
var _variation_strings := []


func _init(p_data := {}, p_size := Vector2.ZERO, p_commonality := 1, p_rotatable := true, p_mirrorable_h := true, p_mirrorable_v := true) -> void:
	data = p_data
	size = p_size
	commonality = p_commonality
	rotatable = p_rotatable
	mirrorable_h = p_mirrorable_h
	mirrorable_v = p_mirrorable_v


func set_data(p_data: Dictionary) -> void:
	data = p_data
	## Add in generating variations and strings here.


func get_data() -> Dictionary:
	return data
