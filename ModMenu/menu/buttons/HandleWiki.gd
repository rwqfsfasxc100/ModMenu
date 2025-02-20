extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")[11]
var hasWikiURL = false
var wikiURL = ""

func _ready():
	hasWiki()
	
	
func hasWiki():
	if not modData == "MODMENU_WIKI_PLACEHOLDER":
		hint_tooltip = "MODMENU_LINKBUTTON_WIKI"
		get_child(0).modulate = "FFFFFF"
		hasWikiURL = true
		wikiURL = modData
	else:
		get_child(0).modulate = "555555"
		hasWikiURL = false
		hint_tooltip = "MODMENU_WIKI_PLACEHOLDER"

func _on_Wiki_pressed():
	if hasWikiURL:
		Achivements.openUrl(wikiURL)
