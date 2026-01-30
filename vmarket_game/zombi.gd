extends CharacterBody2D

@export var speed := 120
@export var selected_name := "player"

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	var direction := Vector2.ZERO

	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if direction != Vector2.ZERO:
		velocity = direction.normalized() * speed
		play_walk_animation(direction) # 👈 เรียกฟังก์ชัน
	else:
		velocity = Vector2.ZERO
		anim.play(selected_name + "_idle")

	move_and_slide()


# ✅ ฟังก์ชันนี้แหละ ที่คุณยังไม่มี
func play_walk_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		anim.play(selected_name + "_walk_side")
		anim.flip_h = dir.x < 0
	elif dir.y < 0:
		anim.play(selected_name + "_walk_up")
	else:
		anim.play(selected_name + "_walk_down")
