extends Button

onready var modData = get_parent().editor_description.split("\n")

func _ready():
	writeVars()

func writeVars():
		
	get_node("Label").text = modData[0]
	hint_tooltip = modData[0] + "\nZIP: " + modData[1]
