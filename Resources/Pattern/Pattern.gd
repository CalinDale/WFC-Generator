## Stores a pattern placed when generating WFC maps
class_name Pattern
extends Resource


export var commonality: int
export var rotatable: bool
export var mirrorable_h: bool
export var mirrorable_v: bool
export var _data: Dictionary setget set_data
export var _size: Vector2 setget set_size

var _variation_strings := []
var _string := ""
var _rotated_size : Vector2
var _center : Vector2
var _rotated_center : Vector2


##Currently having issues here due to using setters and getters in the init that rely on data which hasn't been set yet.

func _init(p_data := {}, p_size := Vector2.ZERO, p_rotatable := true, p_mirrorable_h := true, p_mirrorable_v := true,  p_commonality := 1) -> void:
	commonality = p_commonality
	rotatable = p_rotatable
	mirrorable_h = p_mirrorable_h
	mirrorable_v = p_mirrorable_v
	_size = p_size
	_data = p_data


func _to_string() -> String:
	return _string


func set_data(p_data: Dictionary) -> void:
	_data = p_data
	_string = _stringify_data(_data, _size)
	_variation_strings = _generate_variation_strings()


func set_size(p_size: Vector2) -> void:
	_size = p_size
	_rotated_size = Vector2(p_size.y, p_size.x)
	_center = Vector2(p_size.x / 2, p_size.y / 2)
	_rotated_center = Vector2(_rotated_size.x, _rotated_size.y)


func _stringify_data(p_data: Dictionary, p_size) -> String:
	var stringified_data := ""
	for x in p_size.x:
		for y in p_size.y:
			var coord := Vector2(x,y)
			stringified_data += str(p_data[coord])
	return stringified_data


func _generate_variation_strings() -> Array:
	var variation_strings := [_string]
	
	if rotatable:
		variation_strings.append(_rotate(_data, _size, _center, 90))
		variation_strings.append(_rotate(_data, _size, _center, 180))
		variation_strings.append(_rotate(_data, _size, _center, 270))
	
	print(variation_strings)
	return variation_strings


func _rotate(p_data: Dictionary, p_size: Vector2, p_center: Vector2, degrees: float) -> Dictionary:
	var rotated_data = {}
	for x in p_size.x:
		for y in p_size.y:
			var origin_coords := Vector2(x,y)
			var destination_coords := _rotate_point(origin_coords, p_center, degrees)
			rotated_data[destination_coords] = p_data[origin_coords]
	return rotated_data
		

func _rotate_point(point: Vector2, p_center: Vector2, rotation: float) -> Vector2:
	var relative_to_center := point - p_center
	var new_point = relative_to_center.rotated(deg2rad(rotation)) + p_center
	return new_point
