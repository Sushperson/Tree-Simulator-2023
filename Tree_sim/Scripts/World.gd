extends Node2D


# Declare member variables here. Examples:
export var tile_size = 64
export var tick_length = 1.0
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("RootGrid").cell_size.x = tile_size
	get_node("RootGrid").cell_size.y = tile_size
	get_node("BG_Grid").cell_size.x = tile_size
	get_node("BG_Grid").cell_size.y = tile_size
	get_node("BG_Grid").generate_tiles(get_visible_rect())
	get_node("Tick_clock").connect("timeout", self, "tick")
	get_node("Tick_clock").start(tick_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func tick():
	get_node("Tick_clock").start(tick_length)
	
	var player = get_node("Player")
	player.move()
	player.position = Vector2(player.pos_x * tile_size + tile_size/2, player.pos_y * tile_size + tile_size/2)
	set_player_tile()
	get_node("BG_Grid").generate_tiles(get_visible_rect())
	

# Set a root-tile to the tile that was just left by the player
func set_player_tile():
	var player = get_node("Player")
	var tilemap = get_node("RootGrid")
	tilemap.set_cell(player.get_last_x(), player.get_last_y(), player.last_tile)


# Get a rectangle that describes the currently visible part of the map in
# grid coordinates
func get_visible_rect():
	var camera = get_node("Camera2D")
	return Rect2(((camera.position - (get_viewport_rect().size / 2 * camera.zoom)) / tile_size).floor() - Vector2(1, 1),\
				 (get_viewport_rect().size * camera.zoom / tile_size).ceil() + Vector2(2,2))
