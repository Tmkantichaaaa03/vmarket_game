extends CharacterBody2D

@export var speed = 100
@export var path_points = []  # พิกัดที่ NPC จะเดินไปมา
var current_point = 0

onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if path_points.size() == 0:
		return

	var target = path_points[current_point]
	var direction = (target - global_position).normalized()
	
	velocity = direction * speed
	move_and_slide()

	# เปลี่ยน animation ตามทิศทาง
	if direction.x > 0:
		sprite.animation = "walk_right"
	elif direction.x < 0:
		sprite.animation = "walk_left"
	elif direction.y > 0:
		sprite.animation = "walk_down"
	elif direction.y < 0:
		sprite.animation = "walk_up"

	# ถึงจุดหมายแล้วไปต่อ
	if global_position.distance_to(target) < 5:
		current_point = (current_point + 1) % path_points.size()
