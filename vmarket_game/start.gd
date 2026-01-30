extends Control

@onready var day_night: CanvasModulate = $DayNight

var hour := 17.0

func _process(delta):
	hour += delta * 0.05
	if hour >= 24:
		hour = 0
	update_day_night()

func update_day_night():
	if hour < 18:
		day_night.color = Color(1,1,1)
	elif hour < 20:
		day_night.color = Color(0.8,0.75,0.6)
	else:
		day_night.color = Color(0.2,0.2,0.35)
