extends Control

@onready var img = $Image
@onready var detail_img = $DetailImage
@onready var name_label = $NameLabel
@onready var price_label = $PriceLabel
@onready var desc_label = $DescLabel


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
