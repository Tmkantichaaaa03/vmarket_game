extends Label

func _ready():
	# ตรวจสอบว่ามีชื่อถูกบันทึกใน Global หรือยัง
	if Global.current_username != "":
		text = Global.current_username
	else:
		# หากรันหน้า World โดยไม่ผ่าน Login จะขึ้นว่า Guest
		text = "Guest"
