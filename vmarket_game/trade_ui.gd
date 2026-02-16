extends Control

@onready var label: Label = $Panel/Pokecut1770019084345/label
@onready var list_label = $BillLabel
@onready var total_label = $TotalLabel
@onready var item_box = $ScrollContainer/ItemListBox

var dialogues = [
	"สวัสดี",
	"นายกำลังหาอะไรอยู่หรอ",
	"ฉันว่ามีสิ่งที่นายตามหานะ",
	"ฉันว่านายน่าจะหาได้แล้วนะ"
]

var index := 0
var typing := false

@onready var slots = [
	$ItemLayer/Slot0,
	$ItemLayer/Slot1,
	$ItemLayer/Slot2,
	$ItemLayer/Slot3,
	$ItemLayer/Slot4
]

@onready var http: HTTPRequest = $HTTPRequest

var API_URL = "http://localhost/vmarket/api/products/get_products.php"
var IMAGE_BASE = "http://localhost/vmarket/web_ui/seller_panel/assets/images/"

var buttons=[]
var labels=[]
var start_index:=0


# ---------------- READY ----------------
func _ready():

	await get_tree().process_frame
	update_bill()
	rebuild_item_list()

	label.visible = true
	type_text(dialogues[index])
	http.request(API_URL)



# ---------------- API ----------------
func _on_http_request_request_completed(result,code,headers,body):

	if code!=200:
		print("API ERROR")
		return

	var json=JSON.parse_string(body.get_string_from_utf8())
	if json==null:
		return

	for product in json["data"]:

		# ⭐⭐⭐ เพิ่มกรอง seller_id = 7 ⭐⭐⭐
		if int(product["seller_id"]) != Global.current_shop_id:
			continue

		# (กันกรณีมี approval_status)
		if product.has("approval_status") and product["approval_status"] != "approved":
			continue

		if product["image"]=="":
			continue

		var main_url = IMAGE_BASE + product["image"]

		var detail_url=""
		if product.has("detail_images") and product["detail_images"].size()>0:
			detail_url = IMAGE_BASE + product["detail_images"][0]

		await spawn_item(
			main_url,
			product["name"],
			product["price"],
			product["description"],
			detail_url
		)

	update_view()



# ---------------- SPAWN ----------------
func spawn_item(main_url,pname,price,desc,detail_url):

	var main_tex=await load_texture(main_url)
	if main_tex==null:
		return

	var detail_tex=null
	if detail_url!="":
		detail_tex=await load_texture(detail_url)

	var btn=TextureButton.new()
	btn.texture_normal=main_tex
	btn.custom_minimum_size=Vector2(220,220)
	btn.visible=false

	btn.set_meta("name",pname)
	btn.set_meta("price",price)
	btn.set_meta("image_tex",main_tex)
	btn.set_meta("desc",desc)
	btn.set_meta("detail_tex",detail_tex)

	btn.pressed.connect(_on_item_pressed.bind(btn))

	$ItemLayer.add_child(btn)
	buttons.append(btn)

	var lb=Label.new()
	lb.text=pname+"\n$"+str(price)
	lb.visible=false
	$ItemLayer.add_child(lb)
	labels.append(lb)



# ---------------- LOAD IMG ----------------
func load_texture(url):

	var loader=HTTPRequest.new()
	add_child(loader)

	if loader.request(url)!=OK:
		return null

	var res=await loader.request_completed
	if res[1]!=200:
		return null

	var img=Image.new()
	var e=img.load_jpg_from_buffer(res[3])
	if e!=OK: e=img.load_png_from_buffer(res[3])
	if e!=OK: e=img.load_webp_from_buffer(res[3])
	if e!=OK:
		return null

	img.resize(220,220)
	return ImageTexture.create_from_image(img)



# ---------------- VIEW ----------------
func update_view():

	for b in buttons: b.visible=false
	for lb in labels: lb.visible=false

	for i in range(slots.size()):

		var idx=start_index+i
		if idx>=buttons.size():
			continue

		var slot=slots[i]
		var btn=buttons[idx]
		var lb=labels[idx]

		btn.visible=true
		btn.global_position=slot.global_position-btn.size/2

		lb.visible=true
		lb.global_position=slot.global_position+Vector2(-60,120)



# ---------------- CLICK ----------------
func _on_item_pressed(btn):

	Global.selected_product={
		"name":btn.get_meta("name"),
		"price":btn.get_meta("price"),
		"image":btn.get_meta("image_tex"),
		"description":btn.get_meta("desc"),
		"detail_image":btn.get_meta("detail_tex")
	}

	get_tree().change_scene_to_file("res://vmarket_game/shipping_address.tscn")



# ---------------- SCROLL ----------------
func scroll_right():
	if start_index + slots.size() < buttons.size():
		start_index += 1
		update_view()

func scroll_left():
	if start_index > 0:
		start_index -= 1
		update_view()

func _on_button_pressed():
	scroll_right()



# ---------------- DIALOG ----------------
func _input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			return

		index = (index + 1) % dialogues.size()
		type_text(dialogues[index])


func type_text(text:String)->void:
	typing = true
	label.text = ""

	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(0.05).timeout

	typing = false



# ---------------- BILL TEXT ----------------
func update_bill():

	var txt := ""
	var total := 0
	var grouped = {}

	for item in Global.cart:

		var name = item["name"]
		var price = int(item["price"])

		if not grouped.has(name):
			grouped[name] = {"count":0,"price":price}

		grouped[name]["count"] += 1

	for name in grouped.keys():

		var count = grouped[name]["count"]
		var price = grouped[name]["price"]
		var subtotal = count * price

		txt += name + " x" + str(count) + "    $" + str(subtotal) + "\n"
		total += subtotal

	list_label.text = txt
	total_label.text = "TOTAL : $" + str(total)



# ---------------- CLEAR ----------------
func _on_clear_button_pressed() -> void:
	Global.cart_clear()
	update_bill()
	rebuild_item_list()


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://vmarket_game/Shipping_address.tscn")



# ⭐⭐⭐ UI CART LIST ⭐⭐⭐
func rebuild_item_list():

	for c in item_box.get_children():
		c.queue_free()

	var grouped := {}

	for item in Global.cart:
		var name = item["name"]
		var price = int(item["price"])

		if !grouped.has(name):
			grouped[name] = {"qty":0,"price":price}

		grouped[name]["qty"] += 1

	for name in grouped.keys():

		var qty = grouped[name]["qty"]
		var price = grouped[name]["price"]
		var subtotal = qty * price

		var row = HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_theme_constant_override("separation", 18)

		var name_lbl = Label.new()
		name_lbl.text = name
		name_lbl.custom_minimum_size.x = 30
		row.add_child(name_lbl)

		var price_lbl = Label.new()
		price_lbl.text = str(price) + "$"
		price_lbl.custom_minimum_size.x = 30
		row.add_child(price_lbl)

		var minus = Button.new()
		minus.text = "-"
		minus.custom_minimum_size = Vector2(32,28)
		minus.pressed.connect(_on_minus.bind(name))
		row.add_child(minus)

		var qty_lbl = Label.new()
		qty_lbl.text = str(qty)
		qty_lbl.custom_minimum_size.x = 40
		qty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		row.add_child(qty_lbl)

		var plus = Button.new()
		plus.text = "+"
		plus.custom_minimum_size = Vector2(32,28)
		plus.pressed.connect(_on_plus.bind(name))
		row.add_child(plus)

		var sub_lbl = Label.new()
		sub_lbl.text = "= " + str(subtotal) + "$"
		sub_lbl.custom_minimum_size.x = 40
		row.add_child(sub_lbl)

		item_box.add_child(row)



func _on_plus(name):
	Global.cart_add_by_name(name)
	update_bill()
	rebuild_item_list()


func _on_minus(name):
	Global.cart_remove_one(name)
	update_bill()
	rebuild_item_list()


func _on_buy_button_pressed() -> void:
	get_tree().change_scene_to_file("res://vmarket_game/shopConfirm.tscn")




func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://vmarket_game/startworld.tscn")


func _on_button_2_pressed() -> void:
	scroll_left()
