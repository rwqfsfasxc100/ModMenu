extends Node

func _on_MODNAME_focus_entered():
	var tooltip = get_parent().get_parent().get_parent().get_parent().get_node("Tooltips")
	tooltip.editor_description = editor_description


func _on_MODNAME_mouse_entered():
	var tooltip = get_parent().get_parent().get_parent().get_parent().get_node("Tooltips")
	tooltip.editor_description = editor_description
