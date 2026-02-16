extends Node

# เก็บชื่อผู้ใช้ที่ล็อกอินเข้ามา (เริ่มต้นเป็น Guest)
var current_username: String = "Guest"

var selected_avatar_index: int = 1 
var spawn_name: String = ""

var current_seller_id = -1

# ================================
# PRODUCT ที่เลือก
# ================================
var selected_product = {}

# ตะกร้าสินค้า
var cart = []

# ราคารวม (ของเดิม — ไม่ลบ)
var total_price := 0


# ================================
# ฟังก์ชันเดิม (ไม่แก้)
# ================================
func cart_add(item):
	cart.append(item)
	total_price += int(item["price"])


func cart_clear():
	cart.clear()
	total_price = 0


func add_to_cart(product):
	cart.append(product)


func clear_cart():
	cart.clear()


func get_total():
	var total = 0
	for p in cart:
		total += int(p["price"])
	return total

# ============================
# เพิ่ม / ลด จำนวนสินค้า
# ============================

func cart_remove_one(product_name):

	for i in range(cart.size()):
		if cart[i]["name"] == product_name:
			total_price -= int(cart[i]["price"])
			cart.remove_at(i)
			return


func cart_add_by_name(product_name):

	for item in cart:
		if item["name"] == product_name:
			cart_add(item)
			return
var cart_qty = {}

func qty_add(name):
	if !cart_qty.has(name):
		cart_qty[name] = 0
	cart_qty[name] += 1

func qty_remove(name):
	if cart_qty.has(name):
		cart_qty[name] -= 1
		if cart_qty[name] <= 0:
			cart_qty.erase(name)

func qty_get(name):
	if cart_qty.has(name):
		return cart_qty[name]
	return 0
var user_name = "Player01"
var shipping_address = "Bangkok 10200"
var customer_id : int = 1
var current_shop_id:int = 0
