extends Area2D

@export var shop_id:int = 2   # ตั้ง ID ร้านตรง Inspector ได้

func _input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton:
		if event.pressed:

			print("ENTER SHOP:", shop_id)

			Global.current_shop_id = shop_id

			get_tree().change_scene_to_file(
				"res://vmarket_game/trade_ui.tscn"
			)
