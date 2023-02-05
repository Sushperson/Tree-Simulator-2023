extends Node2D


#  member variables
var pos_x = 0
var pos_y = 0
var min_pos = Vector2(0,0)
var max_pos = Vector2(0,0)
var move_dir = Vector2(0,1)
var last_move_dir = Vector2(0,1)
var last_tile = 0

var path:Array = [[pos_x,pos_y],[pos_x,pos_y]]
var remaining_current_root_tiles = 10
var rock_brakes_used = []
var max_rock_brakes = 1

var water_usage = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_dir = get_input_dir()
	if input_dir != -move_dir and input_dir.length() == 1:
		move_dir = input_dir

func get_input_dir():
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

# move the player on the grid according to current move_dir
func move():
	pos_x += int(move_dir.x)
	pos_y += int(move_dir.y)
	
	update_max_coords()
	path.append([pos_x, pos_y])
	player_tile_id()
	last_move_dir = Vector2(move_dir.x, move_dir.y)
	
func update_max_coords():
	if(pos_x > max_pos.x):
		max_pos.x = pos_x
	elif(pos_x < min_pos.x):
		min_pos.x = pos_x
	
	if(pos_y > max_pos.y):
		max_pos.y = pos_y
	elif(pos_y < min_pos.y):
		min_pos.y = pos_y

func get_pos_vec():
	return Vector2(pos_x, pos_y)


enum richtungen{
	
	ObenUnten,
	LinksRechts,
	ObenLinks,
	UntenLinks,
	ObenRechts,
	UntenRechts,
	
}

# Set curved and straight root tiles
func player_tile_id():
	# v=0, h=1, lo=2, or=3, ru=4, lu=5
	var verederung_move_dir = last_move_dir+move_dir
	
	if move_dir == last_move_dir:
		last_tile = 0
		if move_dir.x == 1 or move_dir.x == -1 :
			last_tile = 1
	else:
		print('##')
		if verederung_move_dir == Vector2(-1,-1):
			if last_move_dir.x == -1:
				last_tile = richtungen.ObenRechts
			else:
				last_tile = richtungen.UntenLinks
		elif verederung_move_dir == Vector2(-1,1):
			if last_move_dir.x == -1:
				last_tile = richtungen.UntenRechts
				
			else:
				last_tile = richtungen.ObenLinks
				
		elif verederung_move_dir == Vector2(1,1):
			if last_move_dir.x == 1:
				last_tile = richtungen.UntenLinks
				
			else:
				last_tile = richtungen.ObenRechts
				
		elif verederung_move_dir == Vector2(1,-1):
			if last_move_dir.x == 1:
				last_tile = richtungen.ObenLinks
				
			else:
				last_tile = richtungen.UntenRechts
				

func get_remaining_rock_brakes():
	return max_rock_brakes - rock_brakes_used.size()

		
func get_last_x():
	return path[-2][0]
	
func get_last_y():
	return path[-2][1]
