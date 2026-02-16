extends Node

# ================================
# ข้อมูลผู้ใช้งาน
# ================================
var user_name: String = "Player01"
var customer_id: int = 1
var shipping_address: String = "Bangkok 10200"
var current_username: String = "Guest" # สำหรับระบบ Login
var selected_avatar_index: int = 1 

# ================================
# ข้อมูลร้านค้าและสินค้า
# ================================
var current_seller_id: int = -1
var current_shop_id: int = 0
var selected_product: Dictionary = {}

# ================================
# ระบบตะกร้าสินค้า (Cart System)
# ================================
var cart: Array = []
var total_price: int = 0

# ฟังก์ชันเพิ่มสินค้าลงตะกร้า (แนะนำให้ใช้ตัวนี้เป็นหลัก)
# item ควรมีโครงสร้าง: {"product_id": 1, "name": "Apple", "price": 50}
func cart_add(item: Dictionary):
	# ตรวจสอบเบื้องต้นว่ามีข้อมูลสำคัญครบไหม
	if !item.has("product_id") and item.has("id"):
		item["product_id"] = item["id"] # ป้องกัน Error ถ้าหน้าที่ส่งมาใช้ชื่อคีย์ว่า id
		
	cart.append(item)
	update_total_price()
	print("Added to cart: ", item["name"], " (ID: ", item.get("product_id"), ")")

# ฟังก์ชันลบสินค้าออก 1 ชิ้น โดยค้นหาจากชื่อ
func cart_remove_one(product_name: String):
	for i in range(cart.size()):
		if cart[i]["name"] == product_name:
			cart.remove_at(i)
			update_total_price()
			return

# ฟังก์ชันล้างตะกร้า
func cart_clear():
	cart.clear()
	total_price = 0
	print("Cart cleared")

# ฟังก์ชันคำนวณราคาทั้งหมดใหม่
func update_total_price():
	var total = 0
	for item in cart:
		total += int(item.get("price", 0))
	total_price = total

# ================================
# ฟังก์ชันเสริม (Utility)
# ================================

# สำหรับดึงจำนวนสินค้าแยกตามชื่อ (เอาไว้โชว์เลข x2, x3 ในหน้าสรุป)
func get_cart_grouped() -> Dictionary:
	var grouped = {}
	for item in cart:
		var n = item["name"]
		if !grouped.has(n):
			grouped[n] = {"qty": 0, "price": item["price"], "product_id": item.get("product_id")}
		grouped[n]["qty"] += 1
	return grouped

# ฟังก์ชันเดิมที่คุณเคยมี (เก็บไว้เพื่อความ Compatible)
func add_to_cart(product):
	cart_add(product)

func clear_cart():
	cart_clear()

func get_total():
	return total_price
