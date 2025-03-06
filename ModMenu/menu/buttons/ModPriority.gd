extends Label

onready var modData = get_parent().get_parent().editor_description.split("\n")

func _ready():
	writeVars()

func writeVars():
	var prio = TranslationServer.translate("MODMENU_BUTTON_PRIORITY_VALUE") + modData[2]
	text = prio
