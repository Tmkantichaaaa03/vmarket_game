extends Control # หรือ Node ตามประเภทสคริปต์ของคุณ

# ... โค้ดอื่นๆ (ถ้ามี) ...

func _on_texture_button_pressed():
	# พิมพ์โค้ดลงที่บรรทัดนี้ (ต้องมีระยะเยื้องเข้าไป 1 Tab)
	get_tree().change_scene_to_file("res://vmarket_game/house_inside.tscn")
