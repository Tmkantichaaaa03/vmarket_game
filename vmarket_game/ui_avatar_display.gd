extends AnimatedSprite2D

# รายชื่อต้องสะกดตรงกับในแถบ Animations
var characters = ["Adam", "Alex", "Amelia", "Bob"]

func _ready():
	# ปรับภาพให้คมชัดแบบ Pixel Art
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	
	# ดึง index ของอวตาร์ที่เลือกจาก Global
	var index = Global.selected_avatar_index
	
	if index >= 0 and index < characters.size():
		# สั่งเล่นอนิเมชั่นตามชื่อตัวละคร
		play(characters[index])
	else:
		# กรณีฉุกเฉินให้เล่นท่า Adam ไว้ก่อน
		play("Adam")
	
	# ปรับขนาดให้พอดีกับช่องโปรไฟล์ (ปรับตัวเลขตามความเหมาะสม)
	scale = Vector2(3, 3)
