extends Button

func _on_ClearMMCFG_pressed():
	var dir = Directory.new()
	dir.open("user://cfg/")
	dir.remove("ModMenu.cfg")
