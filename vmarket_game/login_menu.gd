extends Control

# อ้างอิงโหนด HTTPRequest
@onready var http_request = $HTTPRequest

func _ready():
	# เชื่อมต่อสัญญาณ HTTP
	http_request.request_completed.connect(_on_http_request_completed)
	
	# ตรวจสอบและเชื่อมต่อปุ่ม Login (ชื่อ AcceptBotton ตามภาพ)
	if has_node("AcceptBotton"):
		$AcceptBotton.pressed.connect(_on_login_pressed)
	else:
		print("Error: หาโหนด AcceptBotton ไม่เจอ")

	# ตรวจสอบและเชื่อมต่อปุ่ม Register (ชื่อ RegisterButto ตามภาพ)
	if has_node("RegisterButto"):
		$RegisterButto.pressed.connect(_on_register_pressed)
	else:
		print("Error: หาโหนด RegisterButto ไม่เจอ")

# ฟังก์ชันกดไปหน้าสมัครสมาชิก
func _on_register_pressed():
	# ตรวจสอบ Path ไฟล์ .tscn ของคุณให้ถูกต้อง
	get_tree().change_scene_to_file("res://vmarket_game/register_menu.tscn")

# ฟังก์ชันกด Login
func _on_login_pressed():
	# อ้างอิง Path ไปยัง LineEdit ของ username และ password
	var username = $username/LineEdit.text
	var password = $password/LineEdit2.text
	
	var data = {"username": username, "password": password}
	var json_query = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	var url = "http://localhost/VMARKET/api/auth/login.php"
	
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_query)

# ฟังก์ชันจัดการข้อมูลหลัง Login
func _on_http_request_completed(_result, response_code, _headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code == 200 and response.get("success") == true:
		var user_data = response.get("user_data")
		if user_data:
			# บันทึก Avatar ID ลง Global
			Global.selected_avatar_index = int(user_data.get("avatar_id")) - 1
		
		# วาร์ปเข้าหน้า World
		get_tree().change_scene_to_file("res://vmarket_game/world.tscn")
	else:
		print("Login Failed: ", response.get("message", "Unknown Error"))
