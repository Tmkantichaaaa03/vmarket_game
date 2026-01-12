extends Control

# อ้างอิงโหนดโดยใช้ Path ที่ถูกต้องตามโครงสร้าง World > CharacterB > AnimatedSprite2D
@onready var player_sprite = $CharacterB/AnimatedSprite2D 

# รายชื่อตัวละครที่ต้องเรียงลำดับให้ตรงกับหน้า Register และ Global
var characters = ["Adam", "Alex", "Amelia", "Bob"]

func _ready():
	# 1. ตรวจสอบว่าหาโหนดตัวละครเจอหรือไม่ เพื่อป้องกัน Error "null instance"
	if player_sprite:
		# 2. ปรับภาพให้คมชัดสไตล์ Pixel Art
		player_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST 
		
		# 3. ดึงค่าลำดับตัวละครที่เก็บไว้ใน Global (จากการ Login หรือ Register)
		var index = Global.selected_avatar_index
		
		# 4. ตรวจสอบความถูกต้องของ Index ก่อนสั่งเล่นอนิเมชั่น
		if index >= 0 and index < characters.size():
			var selected_character_name = characters[index]
			
			# สั่งให้ตัวละครเปลี่ยนร่างเป็นตัวที่เลือกมาจริง
			player_sprite.play(selected_character_name)
			print("ยินดีต้อนรับ! คุณกำลังใช้ตัวละคร: ", selected_character_name)
		else:
			print("Error: Index ตัวละครไม่ถูกต้อง (", index, ")")
	else:
		# หากยังขึ้น Error นี้ ให้เช็คการสะกดชื่อโหนดในแถบ Scene อีกครั้ง
		print("Error: ไม่พบโหนด CharacterB/AnimatedSprite2D ในหน้า World")

func _process(_delta):
	# คุณสามารถเพิ่มโค้ดอื่นๆ ที่ต้องทำทุกเฟรมที่นี่ได้
	pass
