extends Control

@onready var label: Label = $Panel/Pokecut1770019084345/label

var dialogues = [
	"สวัสดี",
	"นายกำลังหาอะไรอยู่หรอ",
	"ฉันว่ามีสิ่งที่นายตามหานะ",
	"ฉันว่านายน่าจะหาได้แล้วนะ"
]

var index := 0
var typing := false

func _ready():
	label.visible = true
	type_text(dialogues[index])

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			return

		index += 1
		if index >= dialogues.size():
			index = 0   # 🔁 วนกลับประโยคแรก

		type_text(dialogues[index])

func type_text(text: String) -> void:
	typing = true
	label.text = ""
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(0.05).timeout
	typing = false
