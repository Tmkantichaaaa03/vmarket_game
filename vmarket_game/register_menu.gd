extends Control

# รายชื่ออนิเมชั่นต้องสะกดให้ตรงกับใน SpriteFrames
var characters = ["Adam", "Alex", "Amelia"]
var current_index = 0

func _ready():
	# เริ่มต้นแสดงตัวละครแรก
	update_character()

func _on_right_pressed():
	current_index = (current_index + 1) % characters.size()
	update_character()

func _on_lift_pressed(): # ใช้ชื่อตามโหนดที่คุณตั้ง
	current_index = (current_index - 1 + characters.size()) % characters.size()
	update_character()

func update_character():
	# สั่งให้ AnimatedSprite2D เล่นอนิเมชั่นที่เลือก
	$AnimatedSprite2D.play(characters[current_index])
