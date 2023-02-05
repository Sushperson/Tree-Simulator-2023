extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var aktiv: bool = false
var ausgewaehlt: bool = false

var tree_index:int = -10
var tree_nextpoint:Array = []
var von_index:int = -10

export var links:bool = false
export var oben:bool = false
export var rechts:bool = false

export var beschreibungs_text = ''
export var kosten_nerstoffe: int  = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func skill_aktiviren():
	pass

func skill_punkt_anzeigen():
	get_node(".").visible = true
	if aktiv:
		get_node("KreisFull").visible = true
	else:
		get_node("Kreis").visible = true
		
func skill_punkt_ausblenden():
	get_node(".").visible = false
	get_node("KreisFull").visible = false
	get_node("KreisGruen").visible = false
		
		
func kaufen(var remaining_current_root_tiles):
	if kosten_nerstoffe <= remaining_current_root_tiles:
		aktiv = true
		get_node("KreisFull").visible = true
	return remaining_current_root_tiles-kosten_nerstoffe
	
func auswaehlen():
	get_node("KreisGruen").visible = true
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
