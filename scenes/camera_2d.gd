extends Camera2D

@onready var default_zoom:int = 5
@onready var units_to_pixel = 5
func generate_camera_zoom():
	zoom = (default_zoom/settings.screen_resolution_modifier)*Vector2.ONE
func get_camera_length():
	
	return (1920/zoom.x)*settings.screen_resolution_modifier
