extends Label

onready var modData = get_parent().get_parent().editor_description.split("\n")

func _ready():
	writeVars()

func writeVars():
	var ver = TranslationServer.translate("MODMENU_BUTTON_MOD_VERSION") + modData[4]
	text = ver
