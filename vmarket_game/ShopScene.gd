extends Control

@export var items = ["Potion", "Sword", "Shield"]

func _ready():
	_populate_items()
	$Panel/CloseButton.pressed.connect(_close_shop)

func _populate_items():
	$Panel/ItemList.clear()
	for item_name in items:
		var hbox = HBoxContainer.new()
		var label = Label.new()
		label.text = item_name
		hbox.add_child(label)
		var buy_button = Button.new()
		buy_button.text = "Buy"
		buy_button.pressed.connect(_buy_item.bind(item_name))
		hbox.add_child(buy_button)
		$Panel/ItemList.add_child(hbox)

func _buy_item(item_name):
	print("คุณซื้อไอเท็ม:", item_name)

func _close_shop():
	get_tree().change_scene("res://house_inside.tscn")
