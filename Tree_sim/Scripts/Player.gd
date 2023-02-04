extends Node2D


#  member variables
var pos_x = 0
var pos_y = 0
var move_dir = Vector2(0,1)
var last_move_dir = Vector2(0,1)
var last_tile = 0
var path:Array = [[pos_x,pos_y],[pos_x,pos_y]]
var leben = 10
# Called when the node enters the scene tree for the first time.
func _ready():
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
	
	path.append([pos_x, pos_y])
	player_tile_id()
	last_move_dir = Vector2(move_dir.x, move_dir.y)


enum richtungen{
	
	ObenUnten,
	LinksRechts,
	ObenLinks,
	UntenLinks,
	ObenRechts,
	UntenRechts,
	
	
}


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
				
	
	
	
		

	
		
func get_last_x():
	return path[-2][0]
	
func get_last_y():
	return path[-2][1]
