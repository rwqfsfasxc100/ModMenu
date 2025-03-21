extends Button

var conflictCode = preload("res://ModMenu/menu/buttons/warnings/HasConflict.gd").new()

func _has_finished_validating_mods():
	visible = false
	var parent = get_parent().get_parent().get_parent()
	var conf = conflictCode.checkForConflictsFile(self.name, parent)
	if conf == "hasConflict":
		visible = true
		
		
