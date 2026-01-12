extends Area2D

@export var target_scene: String = "res://vmarket_game/shop_scene.tscn"
@export var spawn_name: String

var can_exit := false

func _on_body_entered(body):
	if body is CharacterBody2D:
		can_exit = true
		print("READY TO EXIT")

func _on_body_exited(body):
	if body is CharacterBody2D:
		can_exit = false
		print("LEFT EXIT")

func _process(delta):
	if can_exit and Input.is_action_just_pressed("interact"):
		print("EXIT HOUSE")
		Global.spawn_name = spawn_name
		get_tree().change_scene_to_file(target_scene)
