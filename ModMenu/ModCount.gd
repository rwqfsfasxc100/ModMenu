extends Label

var modCount = 0

func modCounter():
	var modMenuContainer = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("TabsWithGamepadControl/MODMENU_TAB_MODS/MarginContainer/ScrollContainer/VBoxContainer")
	modCount = modMenuContainer.get_child_count()
	self.text = TranslationServer.translate("MODMENU_MOD_COUNT") % modCount

func _on_ModCount_visibility_changed():
	grow_horizontal = 0
	modCounter()
