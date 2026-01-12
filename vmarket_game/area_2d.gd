extends Area2D

@export var shop_scene_path = "res://shop_scene.tscn"

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact"):
		print("กดเคาเตอร์! ไป ShopScene")
		get_tree().change_scene(shop_scene_path)
