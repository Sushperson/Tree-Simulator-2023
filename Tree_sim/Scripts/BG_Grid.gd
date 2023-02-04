extends TileMap

# generate background tiles for each coordinate in the given rectangle,
# if there isn't already a tile at a given coordinate
func generate_tiles(vis_rect):
	for x in range(vis_rect.position.x, vis_rect.end.x+1):
		for y in range(vis_rect.position.y, vis_rect.end.y+1):
			generate_tile(x,y)

# generate a single background tile at the given coordinates
func generate_tile(x, y):
	if(get_cell(x, y) == -1):
		var tile = -1
		if(y < 0):
			tile = 5
		elif(y == 0):
			tile = 1
		elif(y > 0):
			tile = 0
		set_cell(x, y, tile)
