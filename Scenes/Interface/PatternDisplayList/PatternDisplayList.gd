## Displays
class_name PatternDisplayList
extends ScrollContainer


export var min_display_size : Vector2
export var vbox_container_path : NodePath
export var tiles := {}

var vbox_container : VBoxContainer


func _ready() -> void:
	vbox_container = get_node(vbox_container_path)


func build_list(patterns: Dictionary) -> void:
	var pattern_count := 1
	for pattern_string in patterns:
		var pattern : Pattern = patterns[pattern_string]
		var map_display := MapDisplay.new()
		map_display.tiles = tiles
		map_display.rect_min_size = min_display_size
		map_display.name = "Pattern " + str(pattern_count) + ": " + pattern_string
		
		map_display.size_flags_horizontal = 0
		map_display.size_flags_vertical = 0
		map_display.set("custom_constants/separation", 0)
		
		vbox_container.add_child(map_display)
		map_display.draw_map(pattern.data, pattern.size)
		pattern_count += 1
