## Reads an image and converts it into a WFCMap
class_name ImageReader
extends Node

func convert_to_map(image: Image) -> WFCMap:
	image.lock()
	
	var map := WFCMap.new()
	map.size = image.get_size()
	
	var color_ids : Dictionary
	color_ids[Color.transparent] = 0
	map.tiles[0] = Color.transparent
	
	var new_id := 1
	for x in map.size.x:
		for y in map.size.y:
			var tile_id : int
			var tile_coords := Vector2(x,y)
			var tile_color : Color = image.get_pixelv(tile_coords)
			
			if tile_color in color_ids:
				tile_id = color_ids.get(tile_color)
			else:
				tile_id = new_id
				new_id += 1
				color_ids[tile_color] = tile_id
				map.tiles[tile_id] = tile_color
				
			map.data[tile_coords] = tile_id

	return map
