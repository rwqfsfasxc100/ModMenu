extends Button

var conflictCode = preload("res://ModMenu/menu/buttons/warnings/HasConflict.gd").new()

func _has_finished_validating_mods():
	visible = false
	var parent = get_parent().get_parent().get_parent()
	var conf = conflictCode.checkForConflictsFile(self.name, parent)
	if conf == "hasDeps":
		visible = true

func _process(delta):
	if get_parent().get_node("CONFLICTBUTTON").visible == true:
		focus_neighbour_left = get_path_to(get_parent().get_node("CONFLICTBUTTON"))
	elif get_parent().get_node("CONFLICTBUTTON").visible == false and get_parent().get_node("UPDATEBUTTON").visible == true:
		focus_neighbour_left = get_path_to(get_parent().get_node("UPDATEBUTTON"))
	else:
		focus_neighbour_left = ""
		
	
	if get_parent().get_node("UPDATEBUTTON").visible == true:
		focus_neighbour_bottom = get_path_to(get_parent().get_node("UPDATEBUTTON"))
	else:
		focus_neighbour_bottom = ""
