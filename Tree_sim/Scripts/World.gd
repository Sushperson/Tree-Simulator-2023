extends Node2D


# Declare member variables here. Examples:
export var tile_size = 64
export var tick_length = 1.0

var score = 0

export var hp_bar_pos_x = 20
export var hp_bar_pos_y = 25
export var hp_bar_scale_x = 1
export var hp_bar_scale_y = 25
# var b = "text"
enum spiel_modi{
	wurzeln,
	back_wurzeln,
	pause,
	skilltree,
	verloren
}
var in_spiel_modus: int = spiel_modi.wurzeln



# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("RootGrid").cell_size.x = tile_size
	get_node("RootGrid").cell_size.y = tile_size
	get_node("BG_Grid").cell_size.x = tile_size
	get_node("BG_Grid").cell_size.y = tile_size
	generate_tiles(get_visible_rect())
	get_node("Tick_clock").connect("timeout", self, "tick")
	get_node("Tick_clock").start(tick_length)
	get_node("HUD/HpFill").position.x = hp_bar_pos_x + 50
	get_node("HUD/HpFill").position.y = hp_bar_pos_y
	get_node("HUD/HpFill").scale.x = hp_bar_scale_x * 100
	get_node("HUD/HpFill").scale.y = hp_bar_scale_y
	get_node("HUD/HpFill").modulate = Color(0,255,0)
	get_node("Player/Sprite").set_rotation(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func can_root_move():
	var player = get_node("Player")
	if player.remaining_current_root_tiles <= 0 or not target_cell_free(player.get_pos_vec(), player.move_dir):
		change_mode(spiel_modi.back_wurzeln)
		return false
	else:
		player.remaining_current_root_tiles -= 1
		return true

# change the gamemode
func change_mode(mode):
	in_spiel_modus = mode
	if(mode == spiel_modi.back_wurzeln):
		var player = get_node("Player")
		player.move_dir = Vector2(0,0)
		
		var rootgrid = get_node("RootGrid")
		if player.last_move_dir == Vector2(0,1):
			rootgrid.set_cell(player.pos_x, player.pos_y, 10)
		elif player.last_move_dir == Vector2(1,0):
			rootgrid.set_cell(player.pos_x, player.pos_y, 7)
		elif player.last_move_dir == Vector2(-1,0):
			rootgrid.set_cell(player.pos_x, player.pos_y, 9)
		elif player.last_move_dir == Vector2(0,-1):
			rootgrid.set_cell(player.pos_x, player.pos_y, 8)
			
	elif(mode == spiel_modi.wurzeln):
		var grade_v = 0
		var grade_h = 1
		var kurve_lo = 2
		var kurve_lu = 3
		var kurve_ro = 4
		var kurve_ru = 5
		var kreuzung = 11
		var t_links = 12
		var t_oben = 13
		var t_rechts = 14
		var t_unten = 15
		
		var rootgrid = get_node("RootGrid")
		var player = get_node("Player")
		print(str(rootgrid.get_cell(player.path[-2][0], player.path[-2][1])))
		print(str(player.move_dir))
		if (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == grade_v and player.move_dir == Vector2(-1,0)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_lo and player.move_dir == Vector2(0,1)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_lu and player.move_dir == Vector2(0,1)):
			rootgrid.set_cell(player.path[-2][0], player.path[-2][1], t_links)
		elif (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == grade_h and player.move_dir == Vector2(0,-1)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_lo and player.move_dir == Vector2(1,0)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_ro and player.move_dir == Vector2(-1,0)):
			rootgrid.set_cell(player.path[-2][0], player.path[-2][1], t_oben)
		elif (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == grade_v and player.move_dir == Vector2(1,0)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_ro and player.move_dir == Vector2(0,1)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_ru and player.move_dir == Vector2(0,1)):
			rootgrid.set_cell(player.path[-2][0], player.path[-2][1], t_rechts)
		elif (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == grade_h and player.move_dir == Vector2(0,1)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_lu and player.move_dir == Vector2(1,0)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == kurve_ru and player.move_dir == Vector2(-1,0)):
			rootgrid.set_cell(player.path[-2][0], player.path[-2][1], t_unten)
		elif (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == t_links and player.move_dir == Vector2(1,0)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == t_oben and player.move_dir == Vector2(0,1)) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == t_rechts and player.move_dir == Vector2(-1,0) or (rootgrid.get_cell(player.path[-2][0], player.path[-2][1]) == t_unten and player.move_dir == Vector2(0,-1))):
			rootgrid.set_cell(player.path[-2][0], player.path[-2][1], kreuzung)
	
func _process(delta):
	if Input.is_action_pressed("pause"):
		if not in_spiel_modus == spiel_modi.pause:
			change_mode(spiel_modi.pause)
		else:
			change_mode(spiel_modi.wurzeln)
		
# process a single game step
func tick():
	#restart tick-clock
	get_node("Tick_clock").start(tick_length)
	#generate tiles
	generate_tiles(get_visible_rect())
	var player = get_node("Player")

	if in_spiel_modus == spiel_modi.wurzeln:
		if can_root_move():
			
			#move the player
			player.move()
			player.position = Vector2(player.pos_x * tile_size + tile_size/2, player.pos_y * tile_size + tile_size/2)
			
			set_player_tile()
			health()
			visual_hp()
			score_update()
			resource_yoink()

	elif in_spiel_modus == spiel_modi.back_wurzeln:
		
		if len(player.path) <= 1:
			change_mode(spiel_modi.verloren)
			get_node("HUD/DebugCamSize").set_text('the tree has died') # ?? verloren text
			print('verloren')
		elif(player.move_dir and target_cell_free(player.get_pos_vec(), player.move_dir) and can_root_move()):
			player.move()
			player.position = Vector2(player.pos_x * tile_size + tile_size/2, player.pos_y * tile_size + tile_size/2)
			change_mode(spiel_modi.wurzeln)
		else:
			player.remaining_current_root_tiles += 1
			player.move_dir = Vector2(0,0)
			player.path.pop_back()
			player.pos_x = player.path[-1][0]
			player.pos_y = player.path[-1][1]
			player.position = Vector2(player.path[-1][0] * tile_size + tile_size/2, player.path[-1][1]* tile_size + tile_size/2)
		
	print(get_node("Camera2D").position)
	get_node("HUD/DebugCamSize").set_text(str(player.remaining_current_root_tiles))
	
	player_char()

func target_cell_free(pos, dir):
	return (get_node("RootGrid").get_cell((pos + dir).x, (pos + dir).y) == -1)

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

func health():
	var HUD = get_node("HUD")
	var HpLabel = get_node("HUD/HpBar")
	if HUD.hp_bar > 100:
		HUD.hp_bar = 100
	HUD.hp_bar -= 1
	HpLabel.set_text("HP: " + str(HUD.hp_bar))
	
	


func visual_hp():
	var HUD = get_node("HUD")
	var HpLabel = get_node("HUD/HpBar")
	var HpFill = get_node("HUD/HpFill")
	var HpFill_scale = HpFill.get_scale()
	var HpFill_position = HpFill.get_position()
	
	
	HpFill.scale.x = hp_bar_scale_x * HUD.hp_bar
	HpFill.scale.y = hp_bar_scale_y
	
	HpFill.position.x = hp_bar_pos_x + (HpFill_scale.x / 2)
	HpFill.position.y = hp_bar_pos_y
	
	if HUD.hp_bar > 50:
		HpFill.modulate = Color(0,255,0)
	elif HUD.hp_bar > 25:
		HpFill.modulate = Color(255,140,0)
	else:
		HpFill.modulate = Color(255,0,0)

func score_update():
	score += 1
	get_node("HUD/Score").set_text("Score: " + str(score))
	
func player_char():
	var sprite = get_node("Player/Sprite")
	var player = get_node("Player")
	var rootgrid = get_node("RootGrid")
	
	if in_spiel_modus == spiel_modi.back_wurzeln:
		sprite.texture = load("res://assets/wurzel_highlight.png")
		sprite.modulate.a = 0.3

	elif in_spiel_modus == spiel_modi.wurzeln:
		sprite.texture = load("res://assets/wurzel/ende_o.png")
		sprite.modulate.a = 1
		if player.last_move_dir == Vector2(0,1):
			sprite.set_rotation(0)
		elif player.last_move_dir == Vector2(1,0):
			sprite.set_rotation(PI*1.5)
		elif player.last_move_dir == Vector2(-1,0):
			sprite.set_rotation(PI/2)
		elif player.last_move_dir == Vector2(0,-1):
			sprite.set_rotation(PI)

# generate background and RO tiles for each coordinate in the given rectangle,
# if there isn't already a tile at a given coordinate
func generate_tiles(vis_rect):
	var bg_grid = get_node("BG_Grid")
	var ro_grid = get_node("RO_Grid")
	for x in range(vis_rect.position.x, vis_rect.end.x+1):
		for y in range(vis_rect.position.y, vis_rect.end.y+1):
			if(bg_grid.get_cell(x, y) == -1):
				ro_grid.generate_tile(x,y)
				bg_grid.generate_tile(x,y)

			
func resource_yoink():
	var player = get_node("Player")
	var tilemap = get_node("RO_Grid")
	var HUD = get_node("HUD")
	
	if tilemap.get_cell(player.pos_x, player.pos_y) == 1:
		HUD.hp_bar += 5
		player.remaining_current_root_tiles += 2

func game_over():
	var HUD = get_node("HUD")
	
	if HUD.hp_bar <= 0:
		get_node("Tick_clock").stop()
		
