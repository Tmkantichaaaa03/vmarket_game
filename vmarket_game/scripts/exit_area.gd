extends Area2D

@export var target_scene: String= "res://vmarket_game/world.tscn"
@export var spawn_name: String

var can_use := false

func _on_body_entered(body):
	if body is CharacterBody2D:
		can_use = true
		print("PLAYER CAN EXIT")

func _on_body_exited(body):
	if body is CharacterBody2D:
		can_use = false
		print("PLAYER LEAVE EXIT")

func _process(delta):
	if can_use and Input.is_action_just_pressed("interact"):
		print("EXIT HOUSE")
		Global.spawn_name = spawn_name
		get_tree().change_scene_to_file(target_scene)
