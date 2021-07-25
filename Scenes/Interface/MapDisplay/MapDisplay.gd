## Draws a map of tiles
class_name MapDisplay
extends HBoxContainer


export var tiles := {}


func draw_map(map: Dictionary, size: Vector2) -> void:
	for x in size.x:
		var column := VBoxContainer.new()
		column.size_flags_horizontal = SIZE_EXPAND_FILL
		column.size_flags_vertical = SIZE_EXPAND_FILL
		column.name = "x" + str(x)
		column.set("custom_constants/separation", 0)
		add_child(column)
		
		for y in size.y:
			var coords = Vector2(x,y)
			var tile_id = map[coords]
			var tile_color = tiles[tile_id]
			var tile = ColorRect.new()
			tile.color = tile_color
			tile.size_flags_horizontal = SIZE_EXPAND_FILL
			tile.size_flags_vertical = SIZE_EXPAND_FILL
			tile.name = str(coords)
			column.add_child(tile)
