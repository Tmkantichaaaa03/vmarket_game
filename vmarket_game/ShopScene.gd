extends Control

func _on_texture_button_pressed():
	print("ระบบ: กำลังกลับสู่หน้าภายในบ้าน...")

กำหนด Path ไฟล์หน้าที่จะกลับไป
	var target_scene = "res://vmarket_game/house_inside.tscn"

คำสั่งเปลี่ยนหน้าแบบมาตรฐานของ Godot 4
	var result = get_tree().change_scene_to_file(target_scene)

ตรวจสอบว่าเปลี่ยนหน้าสำเร็จหรือไม่
	if result != OK:
		print("Error: ไม่สามารถไปหน้า ", target_scene, " ได้ ตรวจสอบ Path อีกครั้ง")
