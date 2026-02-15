extends Control

@onready var label: Label = $Panel/Pokecut1770019084345/label
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
		print("โหลดรูปหลักไม่ได้:",main_url)
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
		print("โหลด URL ไม่ได้:",url)
		return null

	var img=Image.new()
	var e=img.load_jpg_from_buffer(res[3])
	if e!=OK: e=img.load_png_from_buffer(res[3])
	if e!=OK: e=img.load_webp_from_buffer(res[3])
	if e!=OK:
		print("decode ไม่ได้:",url)
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


# =========================================================
# ⭐⭐⭐ เพิ่ม Scroll จากโค้ดบน (ไม่แก้ของเดิมแม้แต่บรรทัดเดียว)
# =========================================================

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
