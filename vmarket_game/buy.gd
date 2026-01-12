extends Area2D

# ตรวจสอบให้แน่ใจว่าได้ลากไฟล์ฉาก shop_scene.tscn มาใส่ในช่องนี้ที่หน้า Inspector
@export var target_scene: String = "res://vmarket_game/shop_scene.tscn"
@export var spawn_name: String

var can_exit := false

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_exit = true
		print("READY TO EXIT")

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		can_exit = false
		print("LEFT EXIT")

func _process(delta: float) -> void:
	# ตรวจสอบเงื่อนไขว่าตัวละครอยู่ในพื้นที่ และมีการกดปุ่ม interact (ปุ่ม E)
	if can_exit == true and Input.is_action_just_pressed("interact"):
		print("Switching to Shop...")
		# เปลี่ยนฉากไปยังไฟล์ที่กำหนดไว้ใน target_scene
		get_tree().change_scene_to_file(target_scene)
