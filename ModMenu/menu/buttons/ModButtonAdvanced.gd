extends HBoxContainer

onready var nodeName = editor_description.split("\n")
const emptyConfigButton = preload("res://ModMenu/menu/buttons/DefaultConfig.tscn")
const configIcon = preload("res://ModMenu/menu/buttons/ConfigIcon.tscn")
const toggleButton = preload("res://ModMenu/menu/buttons/ToggleButton.tscn")
onready var modPath = "res://ModMenu/"
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
	if nodeName.size() >= 6:
		if nodeName[5] == "disabled":
			isEnabled = false
	if dir.open(buttonFolder) == OK:
		hasConfigFolder = true
	else:
		pass


func addButtons():
	var toggle = toggleButton.instance()
	var icon = configIcon.instance()
	var config = emptyConfigButton.instance()
	self.add_child(toggle)
	if isEnabled:
		var modConfigButton = load(buttonDirConcat)
		if not modConfigButton == null:
			var button = modConfigButton.instance()
			add_child(button)
		else:
			self.add_child(config)
			self.get_node("Config").add_child(icon)

