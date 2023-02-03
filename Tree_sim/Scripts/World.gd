extends Node2D


# Declare member variables here. Examples:
export var tile_size = 16
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("Player")
	player.position = Vector2(player.pos_x * tile_size, player.pos_y * tile_size)
	set_player_tile()
	get_node("Camera2D/Label").set_text("upper left:" + str(get_visible_rect().position) + "\n" + "lower right: " + str(get_visible_rect().end))

	
func set_player_tile():
	var player = get_node("Player")
	set_cell(player.pos_x, player.pos_y, player_tile_id)


func get_visible_rect():
	return Rect2((get_node("Camera2D").position - get_viewport_rect().size / 2) , get_viewport_rect().size)