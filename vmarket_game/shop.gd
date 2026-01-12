extends Control

# ฟังก์ชันนี้จะทำงานเมื่อเข้าสู่ฉากครั้งแรก (ถ้าไม่ได้ใช้ ลบออกได้ครับ)
func _ready() -> void:
	pass 

# ฟังก์ชันนี้จะทำงานทุกๆ เฟรม (ถ้าไม่ได้ใช้ ลบออกได้เพื่อประหยัดทรัพยากร)
func _process(delta: float) -> void:
	pass

# ฟังก์ชันที่เชื่อมกับปุ่ม "กลับ"
func _on_texture_button_pressed() -> void:
	# คำสั่งเปลี่ยนฉากไปยังหน้า house_inside
	get_tree().change_scene_to_file("res://vmarket_game/world.tscn")
