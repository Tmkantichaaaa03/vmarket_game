extends Control

var characters = ["Adam", "Alex", "Amelia", "Bob"]
var current_index = 0

@onready var sprite = $AnimatedSprite2D 
@onready var http_request = $HTTPRequest
@onready var alert_dialog = $AlertDialog
@onready var back_button = $back 
@onready var register_button = $TextureButton

func _ready():
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
	update_character()
	
	# เชื่อมต่อสัญญาณปุ่ม
	if $right: $right.pressed.connect(_on_right_pressed)
	if $lift: $lift.pressed.connect(_on_lift_pressed)
	if register_button: register_button.pressed.connect(_on_register_pressed)
	if back_button: back_button.pressed.connect(_on_back_pressed)
	
	http_request.request_completed.connect(_on_http_request_completed)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://vmarket_game/login_menu.tscn")

func _on_right_pressed():
	current_index = (current_index + 1) % characters.size()
	update_character()

func _on_lift_pressed():
	current_index = (current_index - 1 + characters.size()) % characters.size()
	update_character()

func update_character():
	sprite.play(characters[current_index])

func _on_register_pressed():
	var username = $Username/LineEdit.text.strip_edges()
	var password = $Password/LineEdit.text.strip_edges()
	var conf_pass = $Confpass/LineEdit.text.strip_edges()
	
	if username == "" or password == "":
		show_alert("กรุณากรอกข้อมูลให้ครบ", false)
		return
		
	if password != conf_pass:
		show_alert("รหัสผ่านไม่ตรงกัน!", false)
		return

	var register_data = {
		"username": username,
		"name": $name/LineEdit.text.strip_edges(),
		"email": $email/LineEdit.text.strip_edges(),
		"address": $address/LineEdit.text.strip_edges(),
		"phone_number": $phone/LineEdit.text.strip_edges(),
		"password": password,
		"avatar_id": current_index + 1
	}
	
	var json_query = JSON.stringify(register_data)
	var headers = ["Content-Type: application/json"]
	var url = "http://localhost/VMARKET/api/auth/register.php"
	
	if register_button: register_button.disabled = true
	http_request.request(url, headers, HTTPClient.METHOD_POST, json_query)

func _on_http_request_completed(_result, response_code, _headers, body):
	if register_button: register_button.disabled = false
	
	var response_text = body.get_string_from_utf8().strip_edges()
	var response = JSON.parse_string(response_text)
	
	# แก้ไขให้รองรับ Code 201 Created ตามรูปภาพ
	if (response_code == 200 or response_code == 201) and response != null:
		if response.get("success") == true:
			if response.has("user_data"):
				Global.current_username = response["user_data"].get("username")
				Global.selected_avatar_index = int(response["user_data"].get("avatar_id"))
			
			# เปลี่ยนไปหน้าหลัก startworld.tscn
			get_tree().change_scene_to_file("res://vmarket_game/startworld.tscn")
		else:
			show_alert(response.get("message", "สมัครสมาชิกไม่สำเร็จ"), false)
	else:
		show_alert("Server Error (Code: %d)" % response_code, false)

func show_alert(text: String, _is_success: bool):
	if alert_dialog:
		alert_dialog.dialog_text = text
		alert_dialog.popup_centered()
	else:
		print("แจ้งเตือน: ", text)
