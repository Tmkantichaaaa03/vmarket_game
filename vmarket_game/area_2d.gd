extends Area2D

@export var shop_id : int = 7

func _on_body_entered(body):

	print("ชนแล้ว:", body.name)

	if body.name == "Player":

		Global.current_seller_id = shop_id
		print("เข้า shop id =", shop_id)

		get_tree().change_scene_to_file("res://trade_ui.tscn")
