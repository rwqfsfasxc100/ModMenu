extends Button

var isEnabled = true
onready var nodeName = get_parent().editor_description
var modPathPrefix = ""

func _ready():
	getModDir()
	ifEnabled()
	handleIcons()

func ifEnabled():
	var disabledMark = "disabled"
	var nameSeparated = nodeName.split("\n")
	var nameCount = nameSeparated.size()
	if nameSeparated[nameCount - 1] == disabledMark:
		isEnabled = false
	
	
func handleIcons():
	if isEnabled:
		get_child(0).texture = load("res://ModMenu/menu/icons/ToggleIconOn.png.stex")
		hint_tooltip = "This mod is currently enabled.\nTo disable this mod and still register here,\nadd the \".disabled\" extension to the filename.\nToggling in the mod menu currently is not possible."
	else:
		get_child(0).texture = load("res://ModMenu/menu/icons/ToggleIconOff.png.stex")
		hint_tooltip = "This mod is currently disabled.\nTo re-enable this mod,\nremove the \".disabled\" extension from the filename.\nToggling in the mod menu currently is not possible."



func _on_Toggle_pressed():
	if isEnabled:
		ResourceLoader.free()
		var dir = Directory.new()
		dir.open(modPathPrefix + nodeName[1])
		dir.rename(modPathPrefix + nodeName[1], modPathPrefix + nodeName[1] + ".disabled")
		if not dir.file_exists(nodeName[1]):
			isEnabled = false
			handleIcons()
	else:
		var moveDir = Directory.new()
		moveDir.rename(modPathPrefix + nodeName[1] + ".disabled", modPathPrefix + nodeName[1])
		isEnabled = true
		handleIcons()

func getModDir():
	
	var gameInstallDirectory = OS.get_executable_path().get_base_dir()
	if OS.get_name() == "OSX":
		gameInstallDirectory = gameInstallDirectory.get_base_dir().get_base_dir().get_base_dir()
	modPathPrefix = gameInstallDirectory.plus_file("mods/")
