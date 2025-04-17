extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")[8]
var hasDiscordURL = false
var discordURL = ""

func _ready():
	hasDiscord()
	
	
func hasDiscord():
	if not modData == "MODMENU_DISCORD_PLACEHOLDER":
		hint_tooltip = "MODMENU_LINKBUTTON_DISCORD"
		get_child(0).modulate = "FFFFFF"
		hasDiscordURL = true
		discordURL = modData
	else:
		get_child(0).modulate = "555555"
		hasDiscordURL = false
		hint_tooltip = "MODMENU_DISCORD_PLACEHOLDER"

func _on_Discord_pressed():
	if hasDiscordURL:
		Achivements.openUrl(discordURL)
