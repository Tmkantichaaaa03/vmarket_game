extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene_to_file("res://vmarket_game/startworld.tscn")
