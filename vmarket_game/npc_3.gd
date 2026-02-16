extends CharacterBody2D

@export var speed := 30.0
@export var move_time := 1.5
@export var idle_time := 1.0

@onready var anim := $AnimatedSprite2D

var direction := Vector2.DOWN
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


# =========================
# เลือก state ใหม่
# =========================
func choose_new_state():
	moving = randi() % 2 == 0

	if moving:
		direction = Vector2(
			randi_range(-1,1),
			randi_range(-1,1)
		)

		if direction == Vector2.ZERO:
			direction = Vector2.DOWN

		direction = direction.normalized()
		timer = move_time
	else:
		timer = idle_time


# =========================
# Animation logic
# =========================
func play_walk_animation():
	var anim_name = get_dir_anim("walk")
	if anim.animation != anim_name:
		anim.play(anim_name)


func play_idle_animation():
	var anim_name = get_dir_anim("idle")
	if anim.animation != anim_name:
		anim.play(anim_name)


# =========================
# หา animation ตามทิศ
# =========================
func get_dir_anim(prefix:String) -> String:

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return prefix + "_right"
		else:
			return prefix + "_left"
	else:
		if direction.y > 0:
			return prefix + "_down"
		else:
			return prefix + "_up"
