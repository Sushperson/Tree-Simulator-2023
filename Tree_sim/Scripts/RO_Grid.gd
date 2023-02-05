extends TileMap

var tile_indices = [[0,0.6],[3,0.2],[4,0.2]]
var cluster_centers = {}
export var max_cluster_dist : float = 10.0
export var cluster_size : float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func generate_tile(x, y):
	if(y > (cluster_size + 1)):
		var nn_dist = nearest_cluster_dist(x, y)
		if(randf() < inter_cluster_dist_prob(max_cluster_dist, nn_dist)):
			var rando = randf()
			var sum = 0.0
			for e in tile_indices:
				if rando < sum + e[1]:
					print("generating cluster on " + str(Vector2(x, y)))
					print("with nn-distance " + str(nn_dist))
					if e[0] >= 1:
						generate_cluster(x, y, e[0], cluster_size/3)
					else:
						generate_cluster(x, y, e[0], rand_range(cluster_size/4, cluster_size*1.5))
					cluster_centers[Vector2(x,y)] = true
					break
				else:
					sum += e[1]
	if(y > 1):
		if(randf() < 0.2 and get_cell(x, y) == -1):
			var rando = randf()
			var sum = 0.0
			for e in tile_indices:
				if rando < sum + e[1]:
					set_cell(x, y, e[0])
					update_bitmask_area(Vector2(x, y))
					break
				else:
					sum += e[1]



func generate_cluster(x_cntr, y_cntr, material, cluster_sz = cluster_size):
	for x in range(x_cntr - cluster_sz, x_cntr + cluster_sz + 1):
		for y in range(y_cntr - cluster_sz, y_cntr + cluster_sz + 1):
			if randf() < dist_prob_func(cluster_sz, Vector2(x_cntr, y_cntr).distance_to(Vector2(x, y))):
				set_cell(x, y, material)
	update_bitmask_region(Vector2(x_cntr, y_cntr) - Vector2(cluster_sz, cluster_sz), Vector2(x_cntr, y_cntr) + Vector2(cluster_sz, cluster_sz))

# probability function for intra-cluster generation
func dist_prob_func(max_dist : float, dist : float):
	return 0.9 + (1/(max_dist-1.0)) - (1/(max_dist-1.0)) * dist
	

# probability function for inter-cluster generation
func inter_cluster_dist_prob(max_dist : float, dist : float):
	return ((0.75 / (max_dist - cluster_size)) * dist) - (cluster_size / (max_dist - cluster_size))

# calculate distance to nearest cluster
func nearest_cluster_dist(x, y):
	for d in range(max_cluster_dist):
		for dx in [-d, d]:
			for dy in range(-d, d+1):
				if cluster_centers.has(Vector2(x,y) + Vector2(dx, dy)):
					return d
		for dy in [-d, d]:
			for dx in range(-d, d+1):
				if cluster_centers.has(Vector2(x,y) + Vector2(dx, dy)):
					return d
	return 100
