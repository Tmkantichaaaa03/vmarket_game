extends Control

# อ้างอิง Path ให้ตรงตาม Scene Tree จริง
@onready var username_input = $username/LineEdit
@onready var password_input = $password/LineEdit2
@onready var http_request = $HTTPRequest

# --- 1. ฟังก์ชันปุ่ม LOGIN (AcceptBotton) ---
func _on_accept_botton_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	
	if username == "" or password == "":
		print("กรุณากรอกข้อมูลให้ครบ")
		return
		
	var data = {"username": username, "password": password}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	print("กำลังส่งข้อมูลล็อกอิน...")
	http_request.request("http://localhost/vmarket_api/login.php", headers, HTTPClient.METHOD_POST, json_data)

# --- 2. ฟังก์ชันรับข้อมูลจาก Server (แก้ไขเรื่อง Warning แล้ว) ---
func _on_http_request_completed(_result, _response_code, _headers, body):
	var response_text = body.get_string_from_utf8()
	print("Server Response Raw: ", response_text)
	
	var response = JSON.parse_string(response_text)
	if response == null:
		print("Error: JSON พัง (ตรวจสอบไฟล์ PHP และ db_connect.php)")
		return

	if response.get("success") == true:
		var user_data = response.get("user_data")
		if user_data:
			Global.current_username = user_data.get("username")
			Global.selected_avatar_index = int(user_data.get("avatar_id")) - 1
		
		print("เข้าสู่ระบบสำเร็จ!")
		get_tree().change_scene_to_file("res://vmarket_game/world.tscn")
	else:
		print("Login Failed: ", response.get("message"))

# --- 3. ฟังก์ชันปุ่มสมัครสมาชิก (RegisterButton) ---
func _on_register_button_pressed():
	print("เปลี่ยนหน้าไปสมัครสมาชิก...")
	# ตรวจสอบว่าชื่อไฟล์ register.tscn ของคุณถูกต้องตาม Path นี้
	get_tree().change_scene_to_file("res://vmarket_game/register.tscn")
