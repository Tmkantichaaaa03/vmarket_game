extends Control

# อ้างอิงโหนดตาม Scene Tree ของคุณ
@onready var http_request = $HTTPRequest
@onready var username_input = $"username/LineEdit"
@onready var password_input = $"password/LineEdit2"

func _ready():
	# ตรวจสอบการเชื่อมต่อสัญญาณ
	if not http_request.is_connected("request_completed", _on_http_request_request_completed):
		http_request.connect("request_completed", _on_http_request_request_completed)

# 1. ฟังก์ชันเมื่อกดปุ่ม ยืนยัน (AcceptBotton)
func _on_accept_botton_pressed():
	# ใช้ .strip_edges() เพื่อลบช่องว่างที่อาจเผลอพิมพ์เกินมา (เหมือนใน Postman)
	var user = username_input.text.strip_edges()
	var password_val = password_input.text.strip_edges() 
	
	if user == "" or password_val == "":
		print("ระบบ: กรุณากรอกข้อมูลให้ครบ")
		return

	# URL ที่ถูกต้องตามโฟลเดอร์ใน XAMPP
	var url = "http://localhost/vmarket/api/auth/login.php"
	
	# Header ต้องระบุว่าเป็น JSON (จุดสำคัญที่ทำให้เหมือน Postman)
	var headers = ["Content-Type: application/json"]
	
	# เตรียมข้อมูล Dictionary (ชื่อ Key ต้องตรงกับที่ PHP รอรับ)
	var auth_data = {
		"username": user,
		"password": password_val
	}
	
	# ต้องใช้ JSON.stringify เพื่อแปลงเป็นข้อความส่งไป (ห้ามส่ง auth_data ไปเฉยๆ)
	var json_query = JSON.stringify(auth_data)
	
	print("ระบบ: กำลังส่งข้อมูลไปยัง vmarket API... (JSON: ", json_query, ")")
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_query)

# 2. ฟังก์ชันรับข้อมูลกลับจาก PHP (ชื่อฟังก์ชันตามที่ Error แจ้งเตือนมา)
func _on_http_request_request_completed(_result, response_code, _headers, body):
	print("--- ได้รับการตอบกลับจากเซิร์ฟเวอร์แล้ว ---")
	print("HTTP Status Code: ", response_code) 
	
	var response_text = body.get_string_from_utf8()
	print("Raw Response: ", response_text) # ดูว่า PHP ตอบอะไรกลับมา
	
	var json = JSON.new()
	var parse_err = json.parse(response_text)
	
	if parse_err == OK:
		var response = json.get_data()
		
		# เช็ค success จาก JSON ที่ PHP ส่งมา
		if response.has("success") and response.success:
			print("ล็อกอินสำเร็จ! ยินดีต้อนรับ: ", response.user_data.username)
			# เปลี่ยนหน้าไปสู่เกมหลัก
			get_tree().change_scene_to_file("res://World.tscn")
		else:
			# แสดงข้อความ Error เช่น Invalid password
			print("การล็อกอินล้มเหลว: ", response.get("message", "Unknown error"))
	else:
		print("Error: ข้อมูลที่ส่งกลับมาไม่ใช่รูปแบบ JSON")
		
func _on_register_button_pressed():
	print("ระบบ: กำลังย้ายไปหน้าสมัครสมาชิก...")
	var error = get_tree().change_scene_to_file("res://vmarket_game/register_menu.tscn")
	
	if error != OK:
		print("Error: ไม่พบไฟล์หน้าสมัครสมาชิก (ตรวจสอบชื่อไฟล์อีกครั้ง)")
