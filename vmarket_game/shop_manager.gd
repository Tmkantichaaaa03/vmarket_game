extends Node

# จำนวนร้านใน DB
var TOTAL_SHOPS := 30

# จำนวนโมเดลในแมพ
var SLOT_COUNT := 17

# เก็บ mapping
var slot_to_shop := {}

func _ready():
	randomize()
	assign_shops()

func assign_shops():
	var ids = []

	# สร้าง list id
	for i in range(1, TOTAL_SHOPS + 1):
		ids.append(i)

	# สุ่ม
	ids.shuffle()

	# เอา 17 ตัวแรก
	for i in range(SLOT_COUNT):
		slot_to_shop[i] = ids[i]

	print("SHOP MAP:", slot_to_shop)


func get_shop_id(slot_index:int) -> int:
	return slot_to_shop.get(slot_index, -1)
