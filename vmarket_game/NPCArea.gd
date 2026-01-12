extends Area2D

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("interact"):
		print("กด NPC แล้ว!")  # ทดสอบก่อน
		get_tree().change_scene("res://ShopScene.tscn")  # เปลี่ยน Scene ร้านค้า
