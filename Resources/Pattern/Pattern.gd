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


func _init(p_data := {}, p_size := Vector2.ZERO, p_rotatable := true, p_mirrorable_h := true, p_mirrorable_v := true,  base_commonality := 1) -> void:
	commonality = base_commonality
	rotatable = p_rotatable
	mirrorable_h = p_mirrorable_h
	mirrorable_v = p_mirrorable_v
	self._size = p_size
	self._data = p_data


func _to_string() -> String:
	return _string


func set_data(p_data: Dictionary) -> void:
	_data = p_data
	if not _data.empty:
		_string = _stringify(p_data, _size)
		_variation_strings = _generate_variation_strings(p_data)
	else:
		_string = "empty pattern"
		_variation_strings = []


func set_size(p_size: Vector2) -> void:
	_size = p_size
	_rotated_size = Vector2(p_size.y, p_size.x)
	_center = Vector2(min(0, (p_size.x - 1) / 2), min(0, (p_size.y - 1) / 2))
	_rotated_center = Vector2(min(0, (_rotated_size.x - 1) / 2), min(0, (_rotated_size.y - 1) / 2))


func _stringify(p_data: Dictionary, p_size: Vector2) -> String:
	var stringified_data := ""
	if p_size.x == 0 or p_size.y == 0:
		stringified_data = "0 size pattern"
	else:
		for x in p_size.x:
			for y in p_size.y:
				var coord := Vector2(x,y)
				stringified_data += str(p_data[coord])
	return stringified_data


## Due to how symetries work, mirroring one way and rotating 180 is the same as mirroring the other way.
# And mirroring both ways is the same as rotating 180
# So if rotation and mirroring either way is allowed, we only need to cover the rotations of one mirror to cover them both.
func _generate_variation_strings(p_data: Dictionary) -> Array:
	var variation_strings := [_string]
	
	if rotatable:
		variation_strings.append(_stringify(_rotate(p_data, _rotated_size, _rotated_center, 90), _rotated_size))
		variation_strings.append(_stringify(_rotate(p_data, _size, _center, 180), _size))
		variation_strings.append(_stringify(_rotate(p_data, _rotated_size, _rotated_center, 270), _rotated_size))
		
		if mirrorable_h or mirrorable_v:
			var mirrored_data := _mirror_h(p_data, _size, _center)
			variation_strings.append(_stringify(mirrored_data, _size))
			
			variation_strings.append(_stringify(_rotate(mirrored_data, _rotated_size, _rotated_center, 90), _rotated_size))
			variation_strings.append(_stringify(_rotate(mirrored_data, _size, _center, 180), _size))
			variation_strings.append(_stringify(_rotate(mirrored_data, _rotated_size, _rotated_center, 270), _rotated_size))
	
	else:
		if mirrorable_h:
			var mirrored_h_data := _mirror_h(p_data, _size, _center)
			variation_strings.append(_stringify(mirrored_h_data, _size))
			
			if mirrorable_v:
				var mirrored_hv_data := _mirror_v(mirrored_h_data, _size, _center)
				variation_strings.append(_stringify(mirrored_hv_data, _size))
		
		if mirrorable_v:
			var mirrored_v_data := _mirror_v(p_data, _size, _center)
			variation_strings.append(_stringify(mirrored_v_data, _size))
	
	return variation_strings


func _rotate(p_data: Dictionary, p_size: Vector2, p_center: Vector2, degrees: float) -> Dictionary:
	var rotated_data = {}
	for x in p_size.x:
		for y in p_size.y:
			var destination_coords := Vector2(x,y)
			var origin_coords := _rotate_point(destination_coords, p_center, -degrees)
			rotated_data[destination_coords] = p_data[origin_coords]
	return rotated_data

func _rotate_point(point: Vector2, p_center: Vector2, rotation: float) -> Vector2:
	var relative_to_center := point - p_center
	var rotated_point = relative_to_center.rotated(deg2rad(rotation)) + p_center
	var rounded_rotated_point = Vector2(round(rotated_point.x), round(rotated_point.y))
	return rounded_rotated_point


func _mirror_h(p_data: Dictionary, p_size: Vector2, p_center: Vector2) -> Dictionary:
	var mirrored_data = {}
	for x in p_size.x:
		for y in p_size.y:
			var destination_coords := Vector2(x,y)
			var origin_coords := _mirror_h_point(destination_coords, p_center)
			mirrored_data[destination_coords] = p_data[origin_coords]
	return mirrored_data

func _mirror_h_point(point: Vector2, p_center: Vector2) -> Vector2:
	var relative_to_center := point - p_center
	var mirrored_point = Vector2(-relative_to_center.x, relative_to_center.y) + p_center
	return mirrored_point


func _mirror_v(p_data: Dictionary, p_size: Vector2, p_center: Vector2) -> Dictionary:
	var mirrored_data = {}
	for x in p_size.x:
		for y in p_size.y:
			var destination_coords := Vector2(x,y)
			var origin_coords := _mirror_v_point(destination_coords, p_center)
			mirrored_data[destination_coords] = p_data[origin_coords]
	return mirrored_data

func _mirror_v_point(point: Vector2, p_center: Vector2) -> Vector2:
	var relative_to_center := point - p_center
	var mirrored_point = Vector2(relative_to_center.x, -relative_to_center.y) + p_center
	return mirrored_point
