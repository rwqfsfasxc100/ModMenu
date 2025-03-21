extends HBoxContainer


func _ready():
	visible = false

func _physics_process(delta):
	var buttonDisplay = Settings.ModMenu["mainSettings"]["buttonDisplay"]
	if buttonDisplay == 2:
		visible = true
	else:
		visible = false
