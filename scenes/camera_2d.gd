extends Camera2D

var default_zoom:int = 5
var units_to_pixel = 5

func get_camera_length() -> float:
	
	return (1920/zoom.x)*settings.screen_resolution_modifier

func get_camera_length_to_field_length_ratio() -> float:
	var camera_length:float = get_camera_length()
	var field_length:float = %measurement_points.total_line
	return camera_length/field_length
	
func generate_camera_zoom():
	return
	var camera_length_before:float = get_camera_length()
	zoom = ((default_zoom/settings.screen_resolution_modifier)*get_camera_length_to_field_length_ratio() * Vector2.ONE) - Vector2.ONE*2
	var camera_length_after:float = get_camera_length()
	
	camera_length_before -= camera_length_after
	camera_length_before /=2
	camera_length_before += camera_length_after/2 -50
	offset.x -= camera_length_before
