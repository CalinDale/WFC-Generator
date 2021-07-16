## Top script for controling the generator scripts and interface.
class_name App
extends Control

onready var wfc_generator : Node = $WFCGenerator
onready var sample_display : Node = $PanelContainer/MapDisplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wfc_generator.go()

func _on_WFCGenerator_sample_read(map: WFCMap) -> void:
	sample_display.draw_map(map)
