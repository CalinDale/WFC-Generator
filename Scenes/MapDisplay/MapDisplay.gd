class_name MapDisplay
extends HBoxContainer
## Draws a map of tiles


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass # Replace with function body.

func _draw_map(map: Dictionary, size: Vector2, tiles: Array) -> void:
	for x in range(0, size.x):
		var line := ""
		for y in range(0, size.y):
			var coords = Vector2(x,y)
			line += str(map.get(coords, false))
		print(line)
