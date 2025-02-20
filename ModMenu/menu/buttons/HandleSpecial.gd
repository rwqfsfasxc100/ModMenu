extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")
var hasSpecialURL = false
var specialURL = ""

func _ready():
	hasDonations()
	
	
func hasDonations():
	if not modData[12] == "MODMENU_CUSTOM_LINK_PLACEHOLDER":
		hint_tooltip = modData[13]
		get_child(0).modulate = "FFFFFF"
		hasSpecialURL = true
		specialURL = modData[12]
		self.visible = true
	else:
		get_child(0).modulate = "555555"
		hasSpecialURL = false
		hint_tooltip = "MODMENU_CUSTOM_LINK_PLACEHOLDER"
		self.visible = false

func _on_Special_pressed():
	if hasSpecialURL:
		Achivements.openUrl(specialURL)
