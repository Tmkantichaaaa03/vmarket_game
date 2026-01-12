extends Area2D

@export var target_scene: String = "res://vmarket_game/house_inside.tscn"

var can_enter := false

func _on_body_entered(body):
	if body is CharacterBody2D:
		can_enter = true
		print("Player entered door area")

func _on_body_exited(body):
	if body is CharacterBody2D:
		can_enter = false
		print("Player left door area")

func _process(delta):
	if can_enter and Input.is_action_just_pressed("interact"):
		print("Changing scene...")
		print(Global.spawn_name)

		get_tree().change_scene_to_file(target_scene)
