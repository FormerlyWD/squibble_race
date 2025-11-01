extends Node

func parse_references():
	ref.spawn_obstacles = %spawn_obstacles
	ref.measurement_points = %measurement_points
	
	ref.signal_win = %signal_win
	ref.UI_run = [
		%distance_of_runner_1,
		%distance_of_runner_2,
		%distance_of_runner_3
	]
func _ready() -> void:
	parse_references()
	
	%end_line_art_comp.position.x = field_info.chosen_length_ft/field_info.pixel_to_feet
	ref.spawn_obstacles.update_total_line()
	ref.spawn_obstacles.spawn_all_obstacles()
	ref.spawn_obstacles.spawn_runner()
	%all_runners.check_runner_order()
	user_data.procession.simulation_procession()
	%main_camera.generate_camera_zoom()
	
	
