extends Node2D


# Declare member variables here. Examples:
export var tile_size = 16
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("Player")
	player.position = Vector2(player.pos_x * tile_size, player.pos_y * tile_size)
	
