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

export var beschreibungs_text = 'hallo'
export var kosten_nerstoffe: int  = 10
export var type:int = 0
export var ast: int  = 100
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
		
		
func gekauft():
	aktiv = true
	get_node("KreisFull").visible = true

	
func auswaehlen():
	get_node("KreisGruen").visible = true
	
	for child_skill in get_node('.').get_children():
		if child_skill.name.length() >= "skill_point".length():
			if child_skill.name.substr(0,"skill_point".length()) == "skill_point":
				child_skill.skill_punkt_anzeigen()
				
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
