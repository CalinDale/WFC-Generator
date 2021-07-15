class_name MapDisplay
extends HBoxContainer
## Draws a map of tiles


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _ready():
	pass # Replace with function body.

func _draw_map(map: WFCMap) -> void:
	for x in range(0, map.size.x):
		var column = VBoxContainer.new()
		column.size_flags_horizontal = SIZE_EXPAND_FILL
		column.size_flags_vertical = SIZE_EXPAND_FILL
		column.set("custom_constants/separation", 0)
		add_child(column)
		for y in range(0, map.size.y):
			var coords = Vector2(x,y)
			var tile_id = map.data[coords]
			var tile_color = map.tiles[tile_id]
			var tile = ColorRect.new()
			tile.color = tile_color
			tile.size_flags_horizontal = SIZE_EXPAND_FILL
			tile.size_flags_vertical = SIZE_EXPAND_FILL
			column.add_child(tile)


func _on_ImageReader_sample_read(sample_map):
	_draw_map(sample_map)
