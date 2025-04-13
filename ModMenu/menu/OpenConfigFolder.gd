extends Button

func _on_OpenConfigFolder_pressed():
	var updateFolder = OS.get_user_data_dir()
	var suffix = "/cfg/"
	OS.shell_open(updateFolder + suffix) 
