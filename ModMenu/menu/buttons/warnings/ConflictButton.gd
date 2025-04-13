extends Button

var conflictCode = preload("res://ModMenu/menu/buttons/warnings/HasConflict.gd").new()

func _has_finished_validating_mods():
	visible = false
	var parent = get_parent().get_parent().get_parent()
	var conf = conflictCode.checkForConflictsFile(self.name, parent)
	if conf == "hasConflict":
		visible = true
		
func _process(delta):
	if get_parent().get_node("MISSINGDEPSBUTTON").visible == true:
		focus_neighbour_right = get_path_to(get_parent().get_node("MISSINGDEPSBUTTON"))
	else:
		get_parent().get_parent().get_parent().get_node("MODNAME")
	
	if get_parent().get_node("UPDATEBUTTON").visible == true:
		focus_neighbour_bottom = get_path_to(get_parent().get_node("UPDATEBUTTON"))
	else:
		focus_neighbour_bottom = ""
