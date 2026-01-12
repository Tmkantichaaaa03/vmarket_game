extends Control

# --- 1. ส่วนการอ้างอิงโหนด (ตรวจสอบ Path ให้ตรงกับ Scene Tree ของคุณ) ---
# โหนดตัวละครที่ใช้เดิน
@onready var walking_player = $CharacterB/AnimatedSprite2D 
# โหนดรูปในกรอบโปรไฟล์ (ภายใต้ CanvasLayer และ TextureRect)
@onready var avatar_profile = $CanvasLayer/TextureRect/AvatarProfile 

# --- 2. การตั้งค่าตัวละคร ---
# รายชื่อตัวละคร (1=Adam, 2=Alex, 3=Amelia, 4=Bob)
var characters = ["Adam", "Alex", "Amelia", "Bob"]

func _ready():
	# สั่งให้ระบบเตรียมข้อมูลและแสดงผลทันทีที่เข้าหน้า World
	update_character_sync()

# ฟังก์ชันสำหรับ Sync ทั้งตัวเดินและรูปในกรอบโปรไฟล์
func update_character_sync():
	# ดึง ID ที่เก็บไว้ตอน Login จาก Global
	var avatar_id = Global.selected_avatar_index
	var index = avatar_id - 1 
	
	if index >= 0 and index < characters.size():
		var selected_name = characters[index]
		
		# อัปเดตตัวละครที่ใช้เดิน
		if walking_player:
			walking_player.animation = selected_name
			walking_player.play()
			walking_player.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		
		# อัปเดตรูปอวตาร์ในกรอบโปรไฟล์
		if avatar_profile:
			avatar_profile.animation = selected_name
			avatar_profile.play()
			avatar_profile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			
		print("ระบบ World: Sync ตัวละคร '", selected_name, "' สำเร็จ")
	else:
		print("Error: Index ตัวละครไม่ถูกต้อง (", index, ")")

# --- 3. ส่วนการเชื่อมต่อปุ่ม (Signals) ---

# ฟังก์ชันสำหรับปุ่มตะกร้าสินค้า
func _on_cart_button_pressed():
	# เปลี่ยนไปยังหน้าตะกร้าสินค้า
	var cart_scene_path = "res://vmarket_game/cart.tscn" 
	
	if FileAccess.file_exists(cart_scene_path):
		get_tree().change_scene_to_file(cart_scene_path)
		print("กำลังไปหน้าตะกร้าสินค้า...")
	else:
		# หาก Error ให้ตรวจสอบว่าชื่อไฟล์ cart.tscn สะกดถูกและอยู่ในโฟลเดอร์ที่ระบุหรือไม่
		print("Error: หาไฟล์ Scene ตะกร้าสินค้าไม่เจอที่: ", cart_scene_path)

# ฟังก์ชันปุ่มอื่นๆ (ถ้ามี)
func _on_register_button_pressed():
	get_tree().change_scene_to_file("res://vmarket_game/register.tscn")


func _on_texture_button_pressed() -> void:
	pass # Replace with function body.
