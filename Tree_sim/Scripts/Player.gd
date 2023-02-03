extends Node2D


#  member variables
var pos_x = 0
var pos_y = 0
var move_dir = Vector2(0,1)
var last_move_dir = Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Tick_clock").connect("timeout", self, "move")
	get_node("Tick_clock").start(1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	if input_dir != -move_dir and input_dir.length() == 1:
		move_dir = input_dir
	
func move():
	pos_x += int(move_dir.x)
	pos_y += int(move_dir.y)
	get_node("Tick_clock").start(1)
	last_move_dir = Vector2(move_dir.x, move_dir.y)




