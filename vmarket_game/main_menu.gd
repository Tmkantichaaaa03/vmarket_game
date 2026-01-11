extends Control

func _on_texture_button_pressed():
	print("ระบบ: กำลังเข้าสู่หน้า Login...")
	

	var target_scene = "res://vmarket_game/login_menu.tscn" 
	
	var error = get_tree().change_scene_to_file(target_scene)
	
	if error != OK:

		print("Error: หาไฟล์ ", target_scene, " ไม่เจอ ตรวจสอบการพิมพ์ตัวเล็ก-ใหญ่ด้วยครับ")
