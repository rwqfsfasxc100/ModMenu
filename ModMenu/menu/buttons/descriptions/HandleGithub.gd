extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")[6]
var hasGithubURL = false
var githubURL = ""

func _ready():
	hasGithub()
	
	
func hasGithub():
	if not modData == "MODMENU_GITHUB_HOMEPAGE_PLACEHOLDER":
		hint_tooltip = "MODMENU_LINKBUTTON_GITHUB"
		get_child(0).modulate = "FFFFFF"
		hasGithubURL = true
		githubURL = modData
	else:
		get_child(0).modulate = "555555"
		hasGithubURL = false
		hint_tooltip = "MODMENU_GITHUB_HOMEPAGE_PLACEHOLDER"

func _on_Github_pressed():
	if hasGithubURL:
		Achivements.openUrl(githubURL)
