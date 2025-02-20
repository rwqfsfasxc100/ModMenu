extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")[10]
var hasDonationsURL = false
var donationsURL = ""

func _ready():
	hasDonations()
	
	
func hasDonations():
	if not modData == "MODMENU_DONATIONS_PLACEHOLDER":
		hint_tooltip = "MODMENU_LINKBUTTON_DONATIONS"
		get_child(0).modulate = "FFFFFF"
		hasDonationsURL = true
		donationsURL = modData
		self.visible = true
	else:
		get_child(0).modulate = "555555"
		hasDonationsURL = false
		hint_tooltip = "MODMENU_DONATIONS_PLACEHOLDER"
		self.visible = false

func _on_Donations_pressed():
	if hasDonationsURL:
		Achivements.openUrl(donationsURL)
