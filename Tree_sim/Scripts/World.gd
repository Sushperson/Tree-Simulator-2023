extends Node2D


# Declare member variables here. Examples:
export var tile_size = 32
export var tick_length = 1
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TileMap").cell_size.x = tile_size
	get_node("TileMap").cell_size.x = tile_size
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
	
	get_node("Camera2D/Label").set_text("upper left:" + str(get_visible_rect().position) + "\n" + "lower right: " + str(get_visible_rect().end))
	
func set_player_tile():
	var player = get_node("Player")
	var tilemap = get_node("TileMap")
	tilemap.set_cell(player.get_last_x(), player.get_last_y(), player.last_tile)


func get_visible_rect():
	return Rect2((get_node("Camera2D").position - get_viewport_rect().size / 2) , get_viewport_rect().size)
