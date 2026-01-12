extends CharacterBody2D

const SPEED := 350.0

@onready var anim := $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	dir.x = Input.get_axis("ui_left", "ui_right")
	dir.y = Input.get_axis("ui_up", "ui_down")

	if dir != Vector2.ZERO:
		velocity = dir.normalized() * SPEED
		play_walk_animation(dir)
	else:
		velocity = Vector2.ZERO
		anim.stop()  # หยุดที่เฟรมล่าสุด

	move_and_slide()


func play_walk_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		anim.play("walk_side")
		anim.flip_h = dir.x < 0
	elif dir.y < 0:
		anim.play("walk_up")
	else:
		anim.play("walk_down")


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
