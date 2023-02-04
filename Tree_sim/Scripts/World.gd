extends Node2D


# Declare member variables here. Examples:
export var tile_size = 64
export var tick_length = 1.0
# var b = "text"
enum spiel_modi{
	wurzeln,
	back_wurzeln,
	pause,
	skilltree
}
var in_spiel_modi: int = spiel_modi.wurzeln



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("RootGrid").cell_size.x = tile_size
	get_node("RootGrid").cell_size.y = tile_size
	get_node("BG_Grid").cell_size.x = tile_size
	get_node("BG_Grid").cell_size.y = tile_size
	get_node("Tick_clock").connect("timeout", self, "tick")
	get_node("Tick_clock").start(tick_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func ist_wurzel_fit():
	var player = get_node("Player")
	player.leben -= 1
	print(player.leben)
	if player.leben <= 0:
		in_spiel_modi = spiel_modi.back_wurzeln
	
func tick():
	get_node("Tick_clock").start(tick_length)
	if in_spiel_modi == spiel_modi.wurzeln:
		var player = get_node("Player")
		player.move()
		player.position = Vector2(player.pos_x * tile_size + tile_size/2, player.pos_y * tile_size + tile_size/2)
		set_player_tile()
		ist_wurzel_fit()
		print(get_node("Camera2D").position)
		get_node("Camera2D/Label").set_text("upper left:" + str(get_visible_rect().position) + "\n" + "lower right: " + str(get_visible_rect().end))
	elif in_spiel_modi == spiel_modi.back_wurzeln:
		if Input.get_action_strength("confirm"):
			in_spiel_modi = spiel_modi.wurzeln
			return
		var player = get_node("Player")
		player.leben += 1
		var last_pos = player.path.pop_back()
		player.position = Vector2(last_pos[0] * tile_size + tile_size/2, last_pos[1]* tile_size + tile_size/2)
		print(get_node("Camera2D").position)
		get_node("Camera2D/Label").set_text("upper left:" + str(get_visible_rect().position) + "\n" + "lower right: " + str(get_visible_rect().end))
	
		
		
func set_player_tile():
	var player = get_node("Player")
	var tilemap = get_node("RootGrid")
	tilemap.set_cell(player.get_last_x(), player.get_last_y(), player.last_tile)



func get_visible_rect():
	var camera = get_node("Camera2D")
	return Rect2((camera.position - (get_viewport_rect().size / 2 * camera.zoom)) / tile_size , get_viewport_rect().size * camera.zoom / tile_size)
