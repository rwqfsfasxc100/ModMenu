extends Sprite

onready var nodeName = get_parent().editor_description.split("\n")
var isEnabled = false
var buttonScript = null
var hasConfig = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ifEnabled()
	ifConfigEnabled()

func ifEnabled():
	var disabledMark = "disabled"
	var hasButton = getModMenuData()
	var nameCount = nodeName.size()
	if nodeName[nameCount - 1] == disabledMark:
		isEnabled = false
	elif hasButton and not buttonScript == null:
		isEnabled = true
	else:
		isEnabled = false

func ifConfigEnabled():
	if hasConfig:
		self.modulate = "ffffff"
	else:
		self.modulate = "555555"


func getModMenuData():
	if nodeName.size() <= 3:
		return null
	else:
		var modFolder = nodeName[3]
		var modMenuData = "res://" + modFolder + "/ModMenu/button/"
		var buttonDir = checkFolderContent(modMenuData)
		if not buttonDir == null:
			var buttonInstance = load(modMenuData + buttonDir).instance()
			var ConfigHandle = Popup.new()
			buttonScript = buttonInstance.script
			ConfigHandle.set_script(buttonScript)
			get_parent().add_child(ConfigHandle)
			return true
	

func checkFolderContent(path):
	var buttonFolderContent = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				buttonFolderContent.append(file_name)
			file_name = dir.get_next()
	
		
	for file in buttonFolderContent:
		if buttonFolderContent.size() == 1:
			var itemName = buttonFolderContent[0]
			var checkName = itemName.split(".tscn")
			if checkName[0] == nodeName[3]:
				return checkName[0] + ".tscn"
		else:
			return null
