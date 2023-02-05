extends Camera2D

var smooth_zoom = 1
var target_zoom = zoom.x

const ZOOM_SPEED = 1

func _ready():
	pass
	

func _process(delta):
	smooth_zoom = lerp(smooth_zoom, target_zoom, ZOOM_SPEED * delta)
	if smooth_zoom != target_zoom:
		set_zoom(Vector2(smooth_zoom, smooth_zoom))
