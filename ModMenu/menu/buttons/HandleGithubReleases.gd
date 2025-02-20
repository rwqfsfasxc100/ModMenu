extends Button

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")[7]
var hasGithubReleasesURL = false
var githubReleasesURL = ""

func _ready():
	hasGithubReleases()
	
	
func hasGithubReleases():
	if not modData == "MODMENU_GITHUB_RELEASES_PLACEHOLDER":
		hint_tooltip = "MODMENU_LINKBUTTON_GITHUB_RELEASES"
		get_child(0).modulate = "FFFFFF"
		hasGithubReleasesURL = true
		githubReleasesURL = modData
		self.visible = true
	else:
		get_child(0).modulate = "555555"
		hasGithubReleasesURL = false
		hint_tooltip = "MODMENU_GITHUB_RELEASES_PLACEHOLDER"
		self.visible = false

func _on_GithubReleases_pressed():
	if hasGithubReleasesURL:
		Achivements.openUrl(githubReleasesURL)
