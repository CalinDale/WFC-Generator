## Top script for controling the generator scripts and interface.
class_name App
extends Control

export var sample_display_path : NodePath
export var pattern_display_list_path : NodePath
export var full_pattern_display_list_path : NodePath
export var tiles := {}

var sample_display : MapDisplay
var pattern_display_list : PatternDisplayList
var full_pattern_display_list : PatternDisplayList

onready var wfc_generator : Node = $WFCGenerator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sample_display = get_node(sample_display_path)
	pattern_display_list = get_node(pattern_display_list_path)
	full_pattern_display_list = get_node(full_pattern_display_list_path)
	start()
	
func start() -> void:
	wfc_generator.go()

func _on_WFCGenerator_sample_read(map: WFCMap) -> void:
	tiles = map.tiles
	sample_display.tiles = tiles
	sample_display.draw_map(map.data, map.size)

func _on_WFCGenerator_patterns_sliced(patterns: Dictionary) -> void:
	pattern_display_list.tiles = tiles
	pattern_display_list.build_list(patterns)

func _on_WFCGenerator_full_pattern_list_built(patterns: Dictionary) -> void:
	full_pattern_display_list.tiles = tiles
	full_pattern_display_list.build_list(patterns)
