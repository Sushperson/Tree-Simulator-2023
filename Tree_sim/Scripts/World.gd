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
	get_node("RootGrid").cell_size.x = tile_size
	get_node("RootGrid").cell_size.y = tile_size
	get_node("BG_Grid").cell_size.x = tile_size
	get_node("BG_Grid").cell_size.y = tile_size
	get_node("BG_Grid").generate_tiles(get_visible_rect())
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
func ist_wurzel_fit():
	var player = get_node("Player")
	player.remaining_current_root_tiles -= 1
	print(player.remaining_current_root_tiles)
	if player.remaining_current_root_tiles <= 0:
		change_mode(spiel_modi.back_wurzeln)

func change_mode(mode):
	in_spiel_modus = mode
	if(mode == spiel_modi.back_wurzeln):
		get_node("Player").move_dir = Vector2(0,0)
	
func _process(delta):
	if Input.is_action_pressed("pause"):
		if not in_spiel_modus == spiel_modi.pause:
			change_mode(spiel_modi.pause)
		else:
			change_mode(spiel_modi.wurzeln)
		
	
func tick():
	get_node("Tick_clock").start(tick_length)
	var player = get_node("Player")

	if in_spiel_modus == spiel_modi.wurzeln:
		#move the player
		player.move()
		player.position = Vector2(player.pos_x * tile_size + tile_size/2, player.pos_y * tile_size + tile_size/2)
		
		set_player_tile()
		ist_wurzel_fit()
		health()
		visual_hp()
		score_update()
		
		get_node("BG_Grid").generate_tiles(get_visible_rect())

	elif in_spiel_modus == spiel_modi.back_wurzeln:
		
		if len(player.path) <= 1:
			change_mode(spiel_modi.verloren)
			get_node("HUD/DebugCamSize").set_text('the tree has died') # ?? verloren text
			print('verloren')
		elif(player.move_dir and target_cell_free(player.get_pos_vec(), player.move_dir) and player.remaining_current_root_tiles > 0):
			player.move()
			player.position = Vector2(player.pos_x * tile_size + tile_size/2, player.pos_y * tile_size + tile_size/2)
			player.remaining_current_root_tiles -= 1
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
	HpLabel.set_text("HP: " + str(HUD.hp_bar))
	if HUD.hp_bar > 100:
		HUD.hp_bar = 100
	else:
		HUD.hp_bar -= 1


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
		
		if player.remaining_current_root_tiles <= 0:
			if player.last_move_dir == Vector2(0,1):
				rootgrid.set_cell(player.pos_x, player.pos_y, 10)
			elif player.last_move_dir == Vector2(1,0):
				rootgrid.set_cell(player.pos_x, player.pos_y, 7)
			elif player.last_move_dir == Vector2(-1,0):
				rootgrid.set_cell(player.pos_x, player.pos_y, 9)
			elif player.last_move_dir == Vector2(0,-1):
				rootgrid.set_cell(player.pos_x, player.pos_y, 8)
		
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
			
			
