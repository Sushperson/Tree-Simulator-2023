extends AudioStreamPlayer


var stone_crunches = [	load("res://sounds/Schotter_crunch1.wav"),\
					 	load("res://sounds/Schotter_crunch2.wav"),\
						load("res://sounds/Schotter_crunch3.wav"),\
						load("res://sounds/Schotter_crunch4.wav") ]
						
var earth_crunches = [	load("res://sounds/Sand_crunch1.wav"),\
						load("res://sounds/Sand_crunch2.wav"),\
						load("res://sounds/Sand_crunch3.wav"),\
						load("res://sounds/Sand_crunch4.wav"),\
						load("res://sounds/Sand_crunch5.wav") ]
						
var donks = [	load("res://sounds/donk1.wav"),\
				load("res://sounds/donk2.wav"),\
				load("res://sounds/donk3.wav") ]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_stone_crunch():
	set_stream(stone_crunches[randi() % stone_crunches.size()])
	play()
	
func play_earth_crunch():
	set_stream(earth_crunches[randi() % earth_crunches.size()])
	play()
	
func play_donk():
	set_stream(donks[randi() % donks.size()])
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
