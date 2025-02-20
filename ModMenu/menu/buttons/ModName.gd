extends Button

onready var modData = get_parent().editor_description.split("\n")

func _ready():
	writeVars()

func writeVars():
		
	text = modData[0]
	hint_tooltip = "ZIP: " + modData[1]
