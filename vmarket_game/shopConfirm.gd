extends Control

@onready var user_label = $UserLabel
@onready var addr_label = $AddressLabel
@onready var items_label = $ItemsLabel
@onready var total_label = $TotalLabel
@onready var http = $HTTPRequest
@onready var confirm_button = $ConfirmButton # ตรวจสอบชื่อ Node ใน Scene ให้ตรงกัน

# URL ของ API (ตรวจสอบตัวสะกด 'orders' ให้ตรงกับโฟลเดอร์ใน XAMPP)
var API = "http://localhost/vmarket/api/orders/create_order.php"

# ---------------- READY ----------------
func _ready():
	# ดึงข้อมูลจาก Global.gd
	user_label.text = "User : " + str(Global.user_name)
	addr_label.text = "Address : " + str(Global.shipping_address)
	
	build_summary()

# ---------------- BUILD BILL (แสดงผลบน UI) ----------------
func build_summary():
	var txt = ""
	var total = 0
	var grouped = {}

	for item in Global.cart:
		var name = item.get("name", "Unknown Item")
		var price = int(item.get("price", 0))

		if !grouped.has(name):
			grouped[name] = {"qty": 0, "price": price}

		grouped[name]["qty"] += 1

	for name in grouped.keys():
		var q = grouped[name]["qty"]
		var p = grouped[name]["price"]
		txt += name + " x" + str(q) + " = $" + str(q * p) + "\n"
		total += q * p

	items_label.text = txt
	total_label.text = "TOTAL : $" + str(total)

# ---------------- BUILD PAYLOAD (เตรียมส่งให้ PHP) ----------------
func build_payload():
	var grouped_ids := {}

	for item in Global.cart:
		# แก้ปัญหา Error: ตรวจสอบทั้ง 'product_id' และ 'id'
		var p_id = item.get("product_id", item.get("id", -1))
		
		if p_id == -1:
			print("Warning: พบบางสินค้าไม่มี ID ในตะกร้า!")
			continue

		if !grouped_ids.has(p_id):
			grouped_ids[p_id] = 0
		grouped_ids[p_id] += 1

	var items_list := []
	for id in grouped_ids.keys():
		items_list.append({
			"product_id": int(id),
			"quantity": grouped_ids[id]
		})

	return {
		"customer_id": Global.customer_id,
		"items": items_list,
		"payment_status": "unpaid" # ส่งค่าเริ่มต้นตามที่ PHP ต้องการ
	}

# ---------------- CONFIRM BUTTON ----------------
func _on_confirm_button_pressed() -> void:
	if Global.cart.is_empty():
		print("ไม่มีสินค้าในตะกร้า")
		return

	# ปิดปุ่มชั่วคราวเพื่อป้องกันการส่งซ้ำ
	if confirm_button:
		confirm_button.disabled = true

	var payload = build_payload()
	var json_string = JSON.stringify(payload)

	print("กำลังส่งข้อมูลไปยัง Server: ", json_string)

	var headers = ["Content-Type: application/json"]
	http.request(API, headers, HTTPClient.METHOD_POST, json_string)

# ---------------- HTTP RESULT ----------------
func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	# เปิดปุ่มให้กลับมาใช้งานได้
	if confirm_button:
		confirm_button.disabled = false

	var response_text = body.get_string_from_utf8()
	print("SERVER RESPONSE: ", response_text)

	var json = JSON.parse_string(response_text)
	
	if json and json.has("success") and json["success"] == true:
		print("สั่งซื้อสำเร็จ! Order ID: ", json.get("order_id"))
		
		# เคลียร์ตะกร้าใน Global.gd
		Global.cart.clear()
		Global.total_price = 0
		
		# แจ้งเตือนผู้ใช้ (ตัวอย่างการเปลี่ยนหน้า)
		# get_tree().change_scene_to_file("res://scenes/OrderSuccess.tscn")
	else:
		var error_msg = json.get("message") if json else "เชื่อมต่อ Server ไม่สำเร็จ"
		print("การสั่งซื้อล้มเหลว: ", error_msg)
