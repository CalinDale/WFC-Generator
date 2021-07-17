## Draws a map of tiles
class_name MapDisplay
extends HBoxContainer

# We should refactor this to just build an imagetexture and display it in a texture rect

func draw_map(map: WFCMap) -> void:
	for x in map.size.x:
		var column = VBoxContainer.new()
		column.size_flags_horizontal = SIZE_EXPAND_FILL
		column.size_flags_vertical = SIZE_EXPAND_FILL
		column.name = "x" + str(x)
		column.set("custom_constants/separation", 0)
		add_child(column)
		
		for y in map.size.y:
			var coords = Vector2(x,y)
			var tile_id = map.data[coords]
			var tile_color = map.tiles[tile_id]
			var tile = ColorRect.new()
			tile.color = tile_color
			tile.size_flags_horizontal = SIZE_EXPAND_FILL
			tile.size_flags_vertical = SIZE_EXPAND_FILL
			tile.name = str(coords)
			column.add_child(tile)
