extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")[9]
var hasNexusURL = false
var nexusURL = ""

func _ready():
	hasNexus()
	
	
func hasNexus():
	if not modData == "MODMENU_NEXUS_PLACEHOLDER":
		hint_tooltip = "MODMENU_LINKBUTTON_NEXUS"
		get_child(0).modulate = "FFFFFF"
		hasNexusURL = true
		nexusURL = modData
	else:
		get_child(0).modulate = "555555"
		hasNexusURL = false
		hint_tooltip = "MODMENU_NEXUS_PLACEHOLDER"

func _on_Nexus_pressed():
	if hasNexusURL:
		Achivements.openUrl(nexusURL)
