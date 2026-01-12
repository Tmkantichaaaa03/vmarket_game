extends CharacterBody2D

const SPEED := 350.0

@onready var anim := $AnimatedSprite2D

# 1. รายชื่อตัวละครให้ตรงกับหน้า Register
var characters = ["Adam", "Alex", "Amelia", "Bob"]
var selected_name = ""

func _ready():
	# 2. ดึงค่าตัวละครที่เลือกมาจาก Global
	selected_name = characters[Global.selected_avatar_index]
	
	# ปรับภาพให้คมชัดสไตล์ Pixel Art
	anim.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	# เริ่มต้นด้วยท่า Idle ของตัวละครนั้น
	anim.play(selected_name)

func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")

	if dir != Vector2.ZERO:
		velocity = dir.normalized() * SPEED
		play_walk_animation(dir)
	else:
		velocity = Vector2.ZERO
		# 3. เมื่อหยุดเดิน ให้กลับไปท่า Idle (ใช้ชื่อตัวละครเป็นชื่ออนิเมชั่น)
		anim.play(selected_name) 

	move_and_slide()

func play_walk_animation(dir: Vector2) -> void:
	
	if abs(dir.x) > abs(dir.y):
		anim.play(selected_name + "_walk_side")
		anim.flip_h = dir.x < 0
	elif dir.y < 0:
		anim.play(selected_name + "_walk_up")
	else:

		anim.play(selected_name + "_walk_down")


func _on_buy_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_buy_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
