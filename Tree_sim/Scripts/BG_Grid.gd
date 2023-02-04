extends TileMap

var dirt_tile_ids = [0,2,4]
var grass_tile_ids = [6,7]

# generate a single background tile at the given coordinates
func generate_tile(x, y):
	if(get_cell(x, y) == -1):
		var tile = -1
		if(y < 0): #sky
			tile = 5
		elif(y == 0): #grass
			tile = grass_tile_ids[randi() % grass_tile_ids.size()]
		elif(y > 0): #dirt
			tile = dirt_tile_ids[randi() % dirt_tile_ids.size()]
		set_cell(x, y, tile)
