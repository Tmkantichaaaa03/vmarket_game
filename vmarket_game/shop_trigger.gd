extends Area2D

@export var shop_id:int = 2   # ตั้ง ID ร้านตรง Inspector ได้

func _input_event(viewport, event, shape_idx):

	if event is InputEventMouseButton:
		if event.pressed:

			print("ENTER SHOP:", shop_id)

			Global.current_shop_id = shop_id

			get_tree().change_scene_to_file(
				"res://vmarket_game/trade_ui.tscn"
			)



@onready var popup = $Popup

var player_inside = false


func _ready():
	popup.visible = false


# =============================
# ตรวจเข้า/ออกพื้นที่
# =============================
func _on_body_entered(body):

	if body.name == "Player":
		player_inside = true
		popup.visible = true


func _on_body_exited(body):

	if body.name == "Player":
		player_inside = false
		popup.visible = false


# =============================
# กดปุ่มเข้า
# =============================
func _input(event):

	if player_inside == false:
		return

	if event.is_action_pressed("ui_accept"): # ← ใช้ E
		Global.current_shop_id = shop_id
		get_tree().change_scene_to_file(
			"res://vmarket_game/trade_ui.tscn"
		)
