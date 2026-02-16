extends Control

@onready var user_label = $UserLabel
@onready var addr_label = $AddressLabel
@onready var items_label = $ItemsLabel
@onready var total_label = $TotalLabel
@onready var http = $HTTPRequest

var API = "http://localhost/vmarket/api/order/create_order.php"


# ---------------- READY ----------------
func _ready():

	user_label.text = "User : " + Global.user_name
	addr_label.text = "Address : " + Global.shipping_address

	build_summary()


# ---------------- BUILD BILL ----------------
func build_summary():

	var txt = ""
	var total = 0
	var grouped = {}

	for item in Global.cart:

		var name = item["name"]
		var price = int(item["price"])

		if !grouped.has(name):
			grouped[name] = {"qty":0,"price":price}

		grouped[name]["qty"] += 1

	for name in grouped.keys():

		var q = grouped[name]["qty"]
		var p = grouped[name]["price"]

		txt += name + " x" + str(q) + " = $" + str(q*p) + "\n"
		total += q*p

	items_label.text = txt
	total_label.text = "TOTAL : $" + str(total)



# ---------------- BUILD PAYLOAD (สำคัญ) ----------------
func build_payload():

	var grouped := {}

	for item in Global.cart:

		var id = int(item["product_id"])

		if !grouped.has(id):
			grouped[id] = 0

		grouped[id] += 1

	var items := []

	for id in grouped.keys():
		items.append({
			"product_id": id,
			"quantity": grouped[id]
		})

	return {
		"customer_id": Global.customer_id,
		"items": items
	}


# ---------------- CONFIRM ----------------



# ---------------- RESULT ----------------



func _on_confirm_button_pressed() -> void:
	
	print("CLICKED")

	if Global.cart.is_empty():
		print("ไม่มีสินค้า")
		return

	var payload = build_payload()
	var json = JSON.stringify(payload)

	print("ส่ง:", json)

	http.request(
		API,
		["Content-Type: application/json"],
		HTTPClient.METHOD_POST,
		json
	)



func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("SERVER:", body.get_string_from_utf8())
