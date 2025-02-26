extends HBoxContainer

onready var nodeName = editor_description.split("\n")
const emptyConfigButton = preload("res://ModMenu/menu/buttons/DefaultConfig.tscn")
const configIcon = preload("res://ModMenu/menu/buttons/ConfigIcon.tscn")
const toggleButton = preload("res://ModMenu/menu/buttons/ToggleButton.tscn")
const scroller = preload("res://SmoothScrollTo.tscn")
onready var modPath = "res://ModMenu/"
const networkHandler = preload("res://ModMenu/menu/buttons/NetworkHandler.tscn")
var hasConfigFolder = false
var isEnabled = true
var buttonFile = []
var buttonFolder = ""
var buttonDirConcat = ""

func _ready():
	buttonFolder = "res://" + nodeName[3] + "/ModMenu/button/"
	buttonDirConcat = buttonFolder + nodeName[3] + ".tscn"
	configFolderCheck()
	addButtons()

func configFolderCheck():
	var dir = Directory.new()
	if nodeName[nodeName.size()-1] == "disabled":
		isEnabled = false
	if dir.open(buttonFolder) == OK:
		hasConfigFolder = true
	else:
		pass


func addButtons():
	var toggle = toggleButton.instance()
	var icon = configIcon.instance()
	var config = emptyConfigButton.instance()
	self.get_node("BTNS").add_child(toggle)
	var buttonFolder = "res://" + nodeName[3] + "/ModMenu/button/"
	var dirCheck = Directory.new()
	if dirCheck.open(buttonFolder) == OK:
		if isEnabled:
			var modConfigButton = load(buttonDirConcat)
			if not modConfigButton == null:
				var button = modConfigButton.instance()
				button.add_child(scroller.instance())
				self.get_node("BTNS").add_child(button)
	else:
		self.get_node("BTNS").add_child(config)
		self.get_node("BTNS").get_node("Config").add_child(icon)
		self.get_node("BTNS").get_node("Config").add_child(scroller.instance())
	
	var hasGithubReleases = nodeName[7]
	if not hasGithubReleases == "MODMENU_GITHUB_RELEASES_PLACEHOLDER":
		add_child(networkHandler.instance())
	
