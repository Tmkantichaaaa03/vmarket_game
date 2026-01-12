extends Control

# --- 1. อ้างอิงโหนด (Path ล่าสุดตามโครงสร้างหน้า Scene ของคุณ) ---
# โหนดตัวละครที่ใช้เดิน
@onready var walking_player = $CharacterB/AnimatedSprite2D 
# โหนดรูปโปรไฟล์ (อยู่ภายใต้ CanvasLayer)
@onready var avatar_profile = $CanvasLayer/AvatarProfile 
# โหนดแสดงชื่อผู้ใช้ (อยู่ภายใต้ CanvasLayer)
@onready var name_label = $CanvasLayer/Label 

# --- 2. การตั้งค่าตัวละคร ---
# รายชื่อแอนิเมชัน (ต้องเรียงลำดับให้ตรงกับ ID ใน Database: 1, 2, 3, 4)
var characters = ["Adam", "Alex", "Amelia", "Bob"]

func _ready():
	# รอให้ทุกอย่างโหลดเสร็จแล้วสั่งอัปเดต UI ทันที
	update_world_ui()

func update_world_ui():
	# --- ส่วนที่ 1: แสดงชื่อผู้ใช้บน Label ---
	if name_label:
		# ดึงชื่อจาก Global มาแสดง
		name_label.text = Global.current_username
		print("ระบบ: แสดงชื่อผู้ใช้สำเร็จ -> ", Global.current_username)
	else:
		print("Error: หาโหนด Label ไม่เจอที่ $CanvasLayer/Label")

	# --- ส่วนที่ 2: Sync ตัวละคร (ตัวเดินและโปรไฟล์) ---
	var avatar_id = Global.selected_avatar_index
	var index = avatar_id - 1 # แปลงเลข 1-4 ให้เป็น Index 0-3
	
	if index >= 0 and index < characters.size():
		var selected_name = characters[index]
		
		# สั่งให้ตัวเดินเล่นแอนิเมชันตามที่เลือก
		if walking_player:
			walking_player.animation = selected_name
			walking_player.play()
			walking_player.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		# สั่งให้รูปโปรไฟล์ในกรอบเล่นแอนิเมชันตัวเดียวกัน
		if avatar_profile:
			avatar_profile.animation = selected_name
			avatar_profile.play()
			avatar_profile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			
		print("ระบบ: Sync ตัวละคร '", selected_name, "' สำเร็จทั้งเดินและโปรไฟล์")
	else:
		print("Error: ID ตัวละครในระบบไม่ถูกต้อง (ได้รับค่า: ", avatar_id, ")")

# --- 3. ส่วนการทำงานของปุ่ม ---
func _on_cart_button_pressed():
	var cart_scene_path = "res://vmarket_game/cart.tscn" 
	if FileAccess.file_exists(cart_scene_path):
		get_tree().change_scene_to_file(cart_scene_path)
		print("กำลังไปหน้าตะกร้าสินค้า...")
	else:
		print("Error: หาไฟล์หน้าตะกร้าไม่เจอ")
