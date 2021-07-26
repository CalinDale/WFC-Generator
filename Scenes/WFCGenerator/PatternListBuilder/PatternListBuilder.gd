## Builds a list of valid pattern variations, and generates a 'lottery' array
## based on how common each pattern should be
class_name PatternListBuilder
extends Node


export var should_prefer_common := true

## builds an array with all pattern strings. There are extra copies of more common pattern strings.
## The generator will randomly select from this array so that it has a higher chance
## of selecting more common patterns.
func build_pattern_lottery(patterns: Dictionary) -> Array:
	var lottery := []
	
	for pattern_string in patterns:
		var pattern : Pattern = patterns[pattern_string]
		if should_prefer_common:
			for lot_number in pattern.commonality:
				lottery.append(pattern_string)
		else:
			lottery.append(pattern_string)
	
	return lottery


func build_full_pattern_list(patterns: Dictionary) -> Dictionary:
	var full_pattern_list := {}
	
	for pattern_string in patterns:
		var pattern : Pattern = patterns[pattern_string]
		
		if should_prefer_common:
			pattern.commonality = _balance_commonality(pattern)
		
		var pattern_variations := _generate_variations(pattern)
		
		for variation_string in pattern_variations:
			if variation_string in full_pattern_list:
				if should_prefer_common:
					full_pattern_list[variation_string].commonality += 1
			else:
				full_pattern_list[variation_string] = pattern_variations[variation_string]
	
	return full_pattern_list


## this function adjusts the commonality of patterns to account for how many variations
## they can have. Otherwise a common pattern with no variations will be less common
## than a rare pattern with many variations.
## The logic is a bit confusing here, see the '_generate_variations' function.
func _balance_commonality(pattern: Pattern) -> int:
	var commonality := pattern.commonality
	var possible_variations := 7
	var variations := 0
	if pattern.can_rotate:
		variations += 3
		if pattern.can_mirror_h or pattern.can_mirror_v:
			variations += 4
	else:
		if pattern.can_mirror_h:
			variations += 1
			if pattern.can_mirror_v:
				variations += 1
		if pattern.can_mirror_v:
			variations += 1
	return commonality * (1 + possible_variations - variations)


## Due to how symetries work, mirroring one way and rotating 180 is the same as mirroring the other way.
# And mirroring both ways is the same as rotating 180
# So if rotation and mirroring either way is allowed, we only need to cover the rotations of one mirror to cover them both.
func _generate_variations(base_pattern: Pattern) -> Dictionary:
	var size = base_pattern.size
	var data = base_pattern.data
	var center := Vector2(max(0, (size.x - 1) / 2), max(0, (size.y - 1) / 2))
	
	var variations := {base_pattern.to_string(): base_pattern}
	
	if base_pattern.can_rotate:
		var rotated_size := Vector2(size.y, size.x)
		var rotated_center := Vector2(max(0, (rotated_size.x - 1) / 2), max(0, (rotated_size.y - 1) / 2))
		
		var rotated_90_data := _rotate_map(data, rotated_size, rotated_center, 90)
		var rotated_90_pattern := base_pattern.duplicate()
		rotated_90_pattern.data = rotated_90_data
		rotated_90_pattern.size = rotated_size
		variations[rotated_90_pattern.to_string()] = rotated_90_pattern
		
		var rotated_180_data := _rotate_map(data, size, center, 180)
		var rotated_180_pattern := base_pattern.duplicate()
		rotated_180_pattern.data = rotated_180_data
		variations[rotated_180_pattern.to_string()] = rotated_180_pattern
		
		var rotated_270_data := _rotate_map(data, rotated_size, rotated_center, 270)
		var rotated_270_pattern := base_pattern.duplicate()
		rotated_270_pattern.data = rotated_270_data
		rotated_270_pattern.size = rotated_size
		variations[rotated_270_pattern.to_string()] = rotated_270_pattern
		
		if base_pattern.can_mirror_h or base_pattern.can_mirror_v:
			var mirrored_data := _mirror_h_map(data, size, center)
			var mirrored_pattern := base_pattern.duplicate()
			mirrored_pattern.data = mirrored_data
			variations[mirrored_pattern.to_string()] = mirrored_pattern
			
			var mirrored_rotated_90_data := _rotate_map(mirrored_data, rotated_size, rotated_center, 90)
			var mirrored_rotated_90_pattern := base_pattern.duplicate()
			mirrored_rotated_90_pattern.data = mirrored_rotated_90_data
			mirrored_rotated_90_pattern.size = rotated_size
			variations[mirrored_rotated_90_pattern.to_string()] = mirrored_rotated_90_pattern
		
			var mirrored_rotated_180_data := _rotate_map(mirrored_data, size, center, 180)
			var mirrored_rotated_180_pattern := base_pattern.duplicate()
			mirrored_rotated_180_pattern.data = mirrored_rotated_180_data
			variations[mirrored_rotated_180_pattern.to_string()] = mirrored_rotated_180_pattern
		
			var mirrored_rotated_270_data := _rotate_map(mirrored_data, rotated_size, rotated_center, 270)
			var mirrored_rotated_270_pattern := base_pattern.duplicate()
			mirrored_rotated_270_pattern.data = mirrored_rotated_270_data
			mirrored_rotated_270_pattern.size = rotated_size
			variations[mirrored_rotated_270_pattern.to_string()] = mirrored_rotated_270_pattern
	
	else:
		if base_pattern.can_mirror_h:
			var mirrored_h_data := _mirror_h_map(data, size, center)
			var mirrored_h_pattern := base_pattern.duplicate()
			mirrored_h_pattern.data = mirrored_h_data
			variations[mirrored_h_pattern.to_string()] = mirrored_h_pattern
		
		if base_pattern.can_mirror_v:
			var mirrored_v_data := _mirror_v_map(data, size, center)
			var mirrored_v_pattern := base_pattern.duplicate()
			mirrored_v_pattern.data = mirrored_v_data
			variations[mirrored_v_pattern.to_string()] = mirrored_v_pattern
			
			if base_pattern.can_mirror_h:
				var mirrored_hv_data := _mirror_h_map(data, size, center)
				var mirrored_hv_pattern := base_pattern.duplicate()
				mirrored_hv_pattern.data = mirrored_hv_data
				variations[mirrored_hv_pattern.to_string()] = mirrored_hv_pattern
	
	return variations


func _rotate_map(data: Dictionary, size: Vector2, center: Vector2, degrees: float) -> Dictionary:
	var rotated_data = {}
	for x in size.x:
		for y in size.y:
			var destination_coords := Vector2(x,y)
			var origin_coords := _rotate_point(destination_coords, center, -degrees)
			rotated_data[destination_coords] = data[origin_coords]
	return rotated_data

func _rotate_point(point: Vector2, center: Vector2, rotation: float) -> Vector2:
	var relative_to_center := point - center
	var rotated_point = relative_to_center.rotated(deg2rad(rotation)) + center
	var rounded_rotated_point = Vector2(round(rotated_point.x), round(rotated_point.y))
	return rounded_rotated_point


func _mirror_h_map(data: Dictionary, size: Vector2, center: Vector2) -> Dictionary:
	var mirrored_data = {}
	for x in size.x:
		for y in size.y:
			var destination_coords := Vector2(x,y)
			var origin_coords := _mirror_h_point(destination_coords, center)
			mirrored_data[destination_coords] = data[origin_coords]
	return mirrored_data

func _mirror_h_point(point: Vector2, center: Vector2) -> Vector2:
	var relative_to_center := point - center
	var mirrored_point = Vector2(-relative_to_center.x, relative_to_center.y) + center
	return mirrored_point


func _mirror_v_map(data: Dictionary, size: Vector2, center: Vector2) -> Dictionary:
	var mirrored_data = {}
	for x in size.x:
		for y in size.y:
			var destination_coords := Vector2(x,y)
			var origin_coords := _mirror_v_point(destination_coords, center)
			mirrored_data[destination_coords] = data[origin_coords]
	return mirrored_data

func _mirror_v_point(point: Vector2, center: Vector2) -> Vector2:
	var relative_to_center := point - center
	var mirrored_point = Vector2(relative_to_center.x, -relative_to_center.y) + center
	return mirrored_point
