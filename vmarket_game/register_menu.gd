extends Control

# รายชื่อตัวละครให้ตรงกับ SpriteFrames
var characters = ["Adam", "Alex", "Amelia", "Bob"]
var current_index = 0

# อ้างอิงโหนด (ตรวจสอบชื่อให้ตรงกับ Scene Tree ของคุณ)
@onready var sprite = $AnimatedSprite2D 
@onready var http_request = $HTTPRequest
@onready var alert_dialog = $AlertDialog
@onready var back_button = $back # อ้างอิงปุ่มย้อนกลับ

func _ready():
	# ตั้งค่าภาพให้คมชัดสไตล์ Pixel Art
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
	update_character()
	
	# เชื่อมต่อสัญญาณจากปุ่มต่างๆ
	$right.pressed.connect(_on_right_pressed)
	$lift.pressed.connect(_on_lift_pressed)
	$TextureButton.pressed.connect(_on_register_pressed)
	back_button.pressed.connect(_on_back_pressed) # เชื่อมต่อปุ่มย้อนกลับ
	
	# เชื่อมต่อสัญญาณ HTTP
	http_request.request_completed.connect(_on_http_request_completed)

# --- ระบบปุ่มย้อนกลับ ---
func _on_back_pressed():
	# เปลี่ยนกลับไปหน้า Login (ตรวจสอบ Path ให้ถูกต้อง)
	get_tree().change_scene_to_file("res://vmarket_game/login_menu.tscn")

# --- ระบบสลับตัวละคร ---
func _on_right_pressed():
	current_index = (current_index + 1) % characters.size()
	update_character()

func _on_lift_pressed():
	current_index = (current_index - 1 + characters.size()) % characters.size()
	update_character()

func update_character():
	sprite.play(characters[current_index])

# --- ระบบส่งข้อมูลสมัครสมาชิก ---
func _on_register_pressed():
	var password = $Password/LineEdit.text
	var conf_pass = $Confpass/LineEdit.text
	
	if password != conf_pass:
		show_alert("รหัสผ่านไม่ตรงกัน!", false)
		return

	# เตรียมข้อมูล JSON ให้ตรงกับ PHP
	var register_data = {
		"username": $Username/LineEdit.text,
		"name": $name/LineEdit.text,
		"email": $email/LineEdit.text,
		"address": $address/LineEdit.text,
		"phone_number": $phone/LineEdit.text,
		"password": password,
		"avatar_id": current_index + 1 # บันทึกตัวละครที่เลือก
	}
	
	var json_query = JSON.stringify(register_data)
	var headers = ["Content-Type: application/json"]
	var url = "http://localhost/VMARKET/api/auth/register.php"
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_query)

# --- ระบบจัดการผลตอบรับจาก Server ---
func _on_http_request_completed(_result, response_code, _headers, body):
	var response_text = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_result = json.parse(response_text)
	
	if parse_result == OK:
		var response = json.get_data()
		if response_code == 200: # สมัครสำเร็จ
			print("สำเร็จ: กำลังเข้าสู่หน้า World...")
			get_tree().change_scene_to_file("res://vmarket_game/world.tscn") 
		else:
			show_alert("ล้มเหลว: " + response.get("message", "เกิดข้อผิดพลาด"), false)
	else:
		show_alert("Error: เซิร์ฟเวอร์ตอบกลับไม่ถูกต้อง", false)

# ฟังก์ชันแสดง Alert
func show_alert(text: String, _is_success: bool):
	if alert_dialog:
		alert_dialog.dialog_text = text
		alert_dialog.popup_centered()
	else:
		print("Alert: ", text)
