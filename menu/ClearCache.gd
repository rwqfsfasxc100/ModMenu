extends Button

var Globals = preload("res://ModMenu/Globals.gd").new()

func _on_ClearCache_pressed():
	Globals.__recursive_delete("user://cache/.Mod_Menu_Cache/")
	Settings.restartGame()
