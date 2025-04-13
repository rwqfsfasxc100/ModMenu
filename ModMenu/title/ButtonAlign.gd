extends HBoxContainer

func _process(delta):
	var btnWidth = self.rect_size
	var nodeRoot = get_node("VBoxContainer/HBoxContainer")
	nodeRoot.get_node("MISSINGDEPS").rect_size.y = btnWidth.y
	nodeRoot.get_node("UPDATE").rect_size.y = btnWidth.y
	nodeRoot.get_node("CONFLICT").rect_size.y = btnWidth.y
