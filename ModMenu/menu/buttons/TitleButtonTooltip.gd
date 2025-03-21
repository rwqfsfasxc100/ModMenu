extends Button

func _ready():
	if Settings.ModMenu["mainSettings"]["displayLocation"] != 1:
		hint_tooltip = ""
