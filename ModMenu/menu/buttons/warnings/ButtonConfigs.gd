extends VBoxContainer



func _on_VBoxContainer2_visibility_changed():
	var updatePrefs = Settings.ModMenu["mainSettings"]["updatePrefs"]
	match updatePrefs:
		0:
			$GithubUpdate.visible = true
			$OpenFolder.visible = false
			$OpenUpdateFolder.visible = false
		1:
			$GithubUpdate.visible = false
			$OpenFolder.visible = false
			$OpenUpdateFolder.visible = true
		2:
			$GithubUpdate.visible = false
			$OpenFolder.visible = true
			$OpenUpdateFolder.visible = false
	if updatePrefs == null:
			$GithubUpdate.visible = false
			$OpenFolder.visible = true
			$OpenUpdateFolder.visible = false
	
	
