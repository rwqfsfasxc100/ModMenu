extends GridContainer

var focusFixed = false

func _process(delta):
	if get_parent().get_parent().editor_description == "validModsVerified" and not focusFixed:
		ensureProperFocus()

func ensureProperFocus():
	if get_parent().get_parent().get_child_count() > 1:
		var btnNode = get_parent().get_node("BTNS/Config")
		var pos = get_parent().get_position_in_parent()
		var modCount = get_parent().get_parent().get_child_count()
		if pos >= 1 and pos <= modCount - 2:
			btnNode.focus_neighbour_top = "../" + get_path_to(get_parent().get_parent().get_child(pos - 1).get_node("BTNS/Config"))
			btnNode.focus_neighbour_bottom = "../" + get_path_to(get_parent().get_parent().get_child(pos + 1).get_node("BTNS/Config"))
		
		if pos == 0:
			btnNode.focus_neighbour_top = ""
			btnNode.focus_neighbour_bottom = "../" + get_path_to(get_parent().get_parent().get_child(pos + 1).get_node("BTNS/Config"))
		if pos == modCount - 1:
			btnNode.focus_neighbour_bottom = ""
			btnNode.focus_neighbour_top = "../" + get_path_to(get_parent().get_parent().get_child(pos - 1).get_node("BTNS/Config"))
		
	#	var p = "../" + get_path_to(get_parent().get_parent().get_child(pos + 1).get_node("BTNS/Config"))
		focusFixed = true
