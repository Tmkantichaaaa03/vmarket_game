extends CharacterBody2D

@export var speed := 30.0
@export var move_time := 1.5
@export var idle_time := 1.0

@onready var anim := $AnimatedSprite2D

var direction := Vector2.ZERO
var timer := 0.0
var moving := false

func _ready():
	randomize()
	choose_new_state()

func _physics_process(delta):
	timer -= delta

	if moving:
		velocity = direction * speed
		move_and_slide()
		play_walk_animation()
	else:
		velocity = Vector2.ZERO
		play_idle_animation()

	if timer <= 0:
		choose_new_state()

func choose_new_state():
	moving = randi() % 2 == 0

	if moving:
		direction = Vector2(
			randi_range(-1, 1),
			randi_range(-1, 1)
		).normalized()

		anim.play("walking")
		timer = move_time
	else:
		anim.play("Idle")
		timer = idle_time


# =========================
# ฟังก์ชันที่ขาดไป 👇
# =========================

func play_walk_animation():
	if anim.animation != "walking":
		anim.play("walking")

func play_idle_animation():
	if anim.animation != "Idle":
		anim.play("Idle")
