extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var poskorektur: Vector2 = Vector2(-120,-590)
var scale_tree = 2


var tree_sprite:Array = [["1_stamm","Stamm",4],["2_astLinks","Links",5],["3_oben","Oben",6],["4_ast_rechts","ObenLinks",4]]
var tree_branches:Array = [[100,101,102,103,104,105],[200,201,202,203,204,205,206,207],[300,301,302,303,304,305,306]]
# Called when the node enters the scene tree for the first time.
func get_tree_sprit(var branches:int):
	
	var index = [-1,-1]
	

func _ready():
	for n in tree_branches:
		for nn in n:
			print(nn,get_tree_sprit(nn))
	
	

	
func set_branches(var branches):


	pass


func _process(delta):
	pass
#	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
