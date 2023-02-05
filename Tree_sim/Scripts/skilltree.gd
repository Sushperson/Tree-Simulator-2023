extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var poskorektur: Vector2 = Vector2(-120,-590)
var scale_tree = 2

var tree_sprite:Array = [["1_stamm","Stamm",4],["2_astLinks","Links",5],["3_oben","Oben",6],["4_ast_rechts","ObenLinks",4]]
var tree_branches:Array = [[100,101,102,103,104,105],[200,201,202,203,204,205,206],[300,301,302,303,304]]
var free_skiel:Array = []
var punkte: Array = ['Node/punkte/Kreis','Full']

var stamm_leve: int = 0

var in_skill = ''
# Called when the node enters the scene tree for the first time.

func get_skill_node():
	return get_node(in_skill)

func skiil_verlassen():

	in_skill = 'Node/punkte/skill_point'
	get_node(in_skill).visible = false
	pass

func skill_tree_aktiv():

	in_skill = 'Node/punkte/skill_point'
	
	get_node(in_skill).visible = true
	get_node(in_skill).auswaehlen()
	pass


func _ready():
	var index = 100
	var laufindex = 0
	for i in get_node('Node/punkte').get_children():
		i.tree_index = int(index+laufindex)
		laufindex += 1
		for ii in get_node('Node/punkte/'+i.name).get_children():
			print(ii.get_path())
			if ii.name == "skill_point":
				ii.tree_index = int(index+laufindex)
				laufindex += 1
		index += 100
		
	for n in tree_branches:
		free_skiel.append([])
		for nn in n:
			free_skiel[-1].append(false)
			#set_branches(nn)
	

func gehe_zu_skill(var gehe_zu):
	# 3 = links, 0 = oben , 1 = rechts ,2 = zurück

	print(in_skill)

	if gehe_zu == 2:
		if get_node(in_skill).get_parent().name.length() >= "skill_point".length():
			if get_node(in_skill).get_parent().name.substr(0,"skill_point".length()) == "skill_point":
				get_node(in_skill).skill_punkt_ausblenden()
				in_skill = get_node(in_skill).get_parent().get_path()
	for child_skill in get_node(in_skill).get_children():
		if child_skill.name.length() >= "skill_point".length():
			if child_skill.name.substr(0,"skill_point".length()) == "skill_point":
				child_skill.skill_punkt_anzeigen()
				if get_node(in_skill).aktiv:
					set_branches(get_node(in_skill).ast)
					if child_skill.links == true and gehe_zu == 3:
						in_skill = child_skill.get_path()
						get_node(in_skill).auswaehlen()
					elif child_skill.oben == true and gehe_zu == 0:
						in_skill = child_skill.get_path()
						get_node(in_skill).auswaehlen()
					elif child_skill.rechts == true and gehe_zu == 1:
						in_skill = child_skill.get_path()
						get_node(in_skill).auswaehlen()
					
		



	
func set_branches(var branches):
	var ast:int = int(branches/100)-1
	var schrit:int = branches-(ast+1)*100
	if ast < len(tree_branches):
		if tree_branches[ast].has(branches):
			if ast == 0:
				var tsi = 1
				var name_sprite = 'Node/'+str(tree_sprite[tsi][0])+'/'+str(tree_sprite[tsi][1])+str(schrit)
				get_node(name_sprite).visible = true
			elif ast == 1:
				var tsi = 2
				var name_sprite = 'Node/'+str(tree_sprite[tsi][0])+'/'+str(tree_sprite[tsi][1])+str(schrit)
				get_node(name_sprite).visible = true
				if schrit > stamm_leve+1 and stamm_leve < tree_sprite[0][2]:
					stamm_leve +=1
					name_sprite = 'Node/'+str(tree_sprite[0][0])+'/'+str(tree_sprite[0][1])+str(stamm_leve)
					get_node(name_sprite).visible = true
			elif ast == 2:
				var tsi = 3
				var name_sprite = 'Node/'+str(tree_sprite[tsi][0])+'/'+str(tree_sprite[tsi][1])+str(schrit)
				get_node(name_sprite).visible = true
				if schrit > stamm_leve+1 and stamm_leve < tree_sprite[0][2]:
					stamm_leve +=1
					name_sprite = 'Node/'+str(tree_sprite[0][0])+'/'+str(tree_sprite[0][1])+str(stamm_leve)
					get_node(name_sprite).visible = true
			





#	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
