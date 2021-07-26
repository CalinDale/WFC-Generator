## Stores a pattern placed when generating WFC maps
class_name Pattern
extends Resource


export var commonality: int
export var data: Dictionary 
export var size: Vector2
export var can_rotate := true
export var can_mirror_h := true
export var can_mirror_v := true


func _init(p_data := {}, p_size := Vector2.ZERO,  base_commonality := 1, p_can_rotate := true, p_can_mirror_h := true, p_can_mirror_v := true) -> void:
	commonality = base_commonality
	size = p_size
	data = p_data
	can_rotate = p_can_rotate
	can_mirror_h = p_can_mirror_h
	can_mirror_v = p_can_mirror_v


func _to_string() -> String:
	var stringified_data := ""
	if size.x == 0 or size.y == 0:
		stringified_data = "0 size pattern"
	else:
		for x in size.x:
			for y in size.y:
				var coord := Vector2(x,y)
				stringified_data += str(data[coord])
	return stringified_data
