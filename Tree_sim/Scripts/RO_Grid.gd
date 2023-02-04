extends TileMap

var tile_indices = [[0,0.7],[1,0.3]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func generate_tile(x, y):
	if(y > 1):
		var neighbour = get_a_neighbour(x, y)
		if neighbour == -1:
			if(randf() < 0.1):
				var rando = randf()
				var sum = 0.0
				for e in tile_indices:
					if rando < sum + e[1]:
						set_cell(x, y, e[0])
						break
					else:
						sum += rando
		else:
			if(randf() < 0.4):
				set_cell(x, y, neighbour)
	update_bitmask_area(Vector2(x, y))


func get_a_neighbour(x, y):
	var neighbours = [Vector2(-1,0), Vector2(1,0), Vector2(0,-1), Vector2(0,1)]
	for coords in neighbours:
		if(get_cell(x + coords.x, y + coords.y) != -1):
			return get_cell(x + coords.x, y + coords.y)
	return -1
