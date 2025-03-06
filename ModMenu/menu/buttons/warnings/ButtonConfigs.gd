extends VBoxContainer



func _on_VBoxContainer2_visibility_changed():
	var children = get_children()
	for child in children:
		remove_child(child)
	var updatePrefs = Settings.ModMenu["mainSettings"]["updatePrefs"]
	match updatePrefs:
		0:
			var AddButton = load("res://ModMenu/menu/buttons/warnings/GithubUpdate.tscn").instance()
			add_child(AddButton)
		1:
			var AddButton = load("res://ModMenu/menu/buttons/warnings/OpenUpdateFolder.tscn").instance()
			add_child(AddButton)
		2:
			var AddButton = load("res://ModMenu/menu/buttons/warnings/OpenFolder.tscn").instance()
			add_child(AddButton)
	
	
