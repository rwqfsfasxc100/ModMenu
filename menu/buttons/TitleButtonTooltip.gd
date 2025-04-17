extends Button

func _ready():
	if Settings.ModMenu["mainSettings"]["displayLocation"] != 1:
		hint_tooltip = ""


func _on_ModMenu_pressed():
	
	var isTitleMenuNode = false
	var parent = get_parent()
	while not isTitleMenuNode:
		var nname = parent.name
		if nname == "TitleMenu":
			isTitleMenuNode = true
		elif parent.name == "TitleScreen":
			return
		else:
			parent = parent.get_parent()
		
#	parent.get_node("NoMargins/ModMenuLayer").visible = true
	var menu = parent.get_node("NoMargins/ModMenuLayer/CenterContainer/TabHintContainer/TabsWithGamepadControl")
	menu.current_tab = 0
