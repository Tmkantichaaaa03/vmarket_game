extends Control

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://vmarket_game/shop.tscn")

func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://vmarket_game/thakyou.tscn")
