extends Control

@onready var label: Label = $Panel/label

var dialogues = [
	"สวัสดี",
	"นายกำลังหาอะไรอยู่หรอ"
]

var index := 0
var typing := false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if typing:
			return

		if not label.visible:
			index = 0
			label.visible = true
			type_text(dialogues[index])
		else:
			index += 1
			if index < dialogues.size():
				type_text(dialogues[index])
			else:
				label.visible = false


func type_text(text: String) -> void:
	typing = true
	label.text = ""
	for i in text.length():
		label.text += text[i]
		await get_tree().create_timer(0.05).timeout
	typing = false
