extends Node2D

@onready var day_night: CanvasModulate = $DayNight

var hour := 17.0

func _process(delta):
	hour += delta * 0.05
	if hour >= 24.0:
		hour = 0.0
	update_day_night()

func update_day_night():
	if hour < 18.0:
		day_night.color = Color(1, 1, 1)          # กลางวัน
	elif hour < 20.0:
		day_night.color = Color(0.8, 0.75, 0.6)   # เย็น
	else:
		day_night.color = Color(0.2, 0.2, 0.35)   # กลางคืน





func _on_shop_trigger_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
