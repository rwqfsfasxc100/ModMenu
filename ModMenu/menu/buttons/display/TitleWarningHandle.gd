extends Button

var KBCFocus = false
var KBMFocus = false

func _ready():
	visible = false
	get_node("MarginContainer").visible = false

func _process(delta):
	if get_node("MarginContainer/VBoxContainer3/VBoxContainer/ConflictBox/CONFLICT").hasConflicts == true or get_node("MarginContainer/VBoxContainer3/VBoxContainer/MissingDepsBox/MISSINGDEPS").hasMissingDependancies == true or get_node("MarginContainer/VBoxContainer3/VBoxContainer/UpdateBox/UPDATE").hasUpdates == true:
		visible = true
	else:
		visible = false
	
	if KBMFocus or KBCFocus:
		get_node("MarginContainer").visible = true
	else:
		get_node("MarginContainer").visible = false
	



func _on_Updates_mouse_entered():
	KBMFocus = true



func _on_Updates_mouse_exited():
	KBMFocus = false


func _on_Updates_focus_entered():
	KBCFocus = true


func _on_Updates_focus_exited():
	KBCFocus = false


func _on_Updates_pressed():
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
	parent.get_node("NoMargins/ModMenuLayer/CenterContainer/TabHintContainer/TabsWithGamepadControl").current_tab = 1
	
