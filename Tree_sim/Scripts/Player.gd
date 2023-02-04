extends Node2D


#  member variables
var pos_x = 0
var pos_y = 0
var move_dir = Vector2(0,1)
var last_move_dir = Vector2(0,1)
var last_tile = 0
var path = [[pos_x,pos_y],[pos_x,pos_y]]

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
	path.append([pos_x, pos_y])
	get_node("Tick_clock").start(1)
	player_tile_id()
	last_move_dir = Vector2(move_dir.x, move_dir.y)


enum richtungen{
	# v=0, h=1, lo=2, or=3, ru=4, lu=5
	ObenUnten,
	LinksRechts,
	ObenLinks,
	ObenRechts,
	UntenLinks,
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
				print("1",last_tile)
			else:
				last_tile = richtungen.UntenLinks
				print("2",last_tile)
		elif verederung_move_dir == Vector2(-1,1):
			if last_move_dir.x == -1:
				last_tile = richtungen.UntenRechts
				print("3",last_tile)
				
			else:
				last_tile = richtungen.ObenLinks
				print("4",last_tile)
				
		elif verederung_move_dir == Vector2(1,1):
			if last_move_dir.x == 1:
				last_tile = richtungen.UntenLinks
				print("5",last_tile)
				
			else:
				last_tile = richtungen.ObenRechts
				print("6",last_tile)
				
		elif verederung_move_dir == Vector2(1,-1):
			if last_move_dir.x == 1:
				last_tile = richtungen.ObenLinks
				print("7",last_tile)
				
			else:
				last_tile = richtungen.UntenRechts
				print("8",last_tile)
				
	
	
	
		

	
		
		
