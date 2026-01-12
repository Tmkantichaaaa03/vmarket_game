extends Control

@onready var username_input = $username/LineEdit
@onready var password_input = $password/LineEdit2
@onready var http_request = $HTTPRequest

func _on_accept_botton_pressed():
	var username = username_input.text.strip_edges()
	var password = password_input.text.strip_edges()
	
	if username == "" or password == "":
		print("กรุณากรอกข้อมูลให้ครบ")
		return
		
	var data = {"username": username, "password": password}
	var json_data = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	
	var url = "http://127.0.0.1/vmarket/api/auth/login.php"
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)

func _on_http_request_completed(_result, response_code, _headers, body):
	if response_code != 200:
		print("เชื่อมต่อล้มเหลว")
		return

	var response_text = body.get_string_from_utf8().strip_edges()
	var response = JSON.parse_string(response_text)
	
	if response and response.get("success") == true:
		var user_data = response.get("user_data")
		
		# บันทึกค่าลง Global เพื่อส่งต่อไปหน้า World
		Global.current_username = user_data.get("username")
		Global.selected_avatar_index = int(user_data.get("avatar_id"))
		
		print("ล็อกอินสำเร็จ! กำลังไปหน้า World...")
		get_tree().change_scene_to_file("res://vmarket_game/world.tscn")
	else:
		print("Login Failed: ", response.get("message") if response else "Error")
