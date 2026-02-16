extends Control

@onready var img = $Image
@onready var detail_img = $DetailImage
@onready var name_label = $NameLabel
@onready var price_label = $PriceLabel
@onready var desc_label = $DescLabel
@onready var qty_label = $QtyLabel
var quantity := 1

func _ready():

	if Global.selected_product == null:
		print("No product selected")
		return

	var p = Global.selected_product

	img.texture = p["image"]
	name_label.text = str(p["name"])
	price_label.text = "$" + str(p["price"])
	desc_label.text = str(p["description"])

	if p.has("detail_image") and p["detail_image"] != null:
		detail_img.texture = p["detail_image"]



# ===============================
# ⭐⭐⭐ อัปเดตบิลด้านล่าง
# (ไม่ลบ — ไม่แก้)
# ===============================


# ===============================
# กดเพิ่มสินค้า
# ===============================
func _on_add_button_pressed() -> void:

	if Global.selected_product == null:
		return

	for i in quantity:

		var item = {
			"name": Global.selected_product["name"],
			"price": Global.selected_product["price"],
			"image": Global.selected_product["image"]
		}
		Global.qty_add(item["name"])
		Global.cart_add(item)

	print("เพิ่มจำนวน =", quantity)
	
	get_tree().change_scene_to_file("res://vmarket_game/trade_ui.tscn")

# ===============================
# ⭐⭐⭐ ไปหน้า TradeUI
# ===============================
func _on_checkout_pressed():
	get_tree().change_scene_to_file("res://vmarket_game/trade_ui.tscn")



func _on_plus_button_pressed():
	quantity += 1
	qty_label.text = str(quantity)


func _on_minus_button_pressed():
	quantity = max(1, quantity - 1)
	qty_label.text = str(quantity)
