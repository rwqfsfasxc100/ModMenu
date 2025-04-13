extends TextureRect

var updateDir = "user://cache/.Mod_Menu_Cache/conflicts/conflicts.modmenucache"

export var hasConflicts = false

func _ready():
	visible = false

func _process(delta):
	getModData()

func getModData():
	var updateCounter = 0
	var file = File.new()
	file.open(updateDir, File.READ)
	var currentUpdates = file.get_as_text()
	file.close()
	var mods = currentUpdates.split("\n")
	for mod in mods:
		if mod == "":
			return
		var data = mod.split("~||~")
		updateCounter += 1
	if updateCounter >= 1:
		visible = true
		hasConflicts = true
	else:
		visible = false
		hasConflicts = false


func _on_CONFLICT_visibility_changed():

	getModData()
