extends Button

onready var modData = get_parent().editor_description.split("\n")

func _ready():
	writeVars()

func writeVars():
	var modID = ""
	get_node("Label").text = modData[0]
	if not modData[15] == "MODMENU_ID_PLACEHOLDER":
		modID = modData[15]
	else:
		modID = TranslationServer.translate("MODMENU_ID_PLACEHOLDER")
	hint_tooltip = modData[0] + "\n" + modID + "\n" + TranslationServer.translate("MODMENU_MOD_ZIPFILE") + modData[1]
