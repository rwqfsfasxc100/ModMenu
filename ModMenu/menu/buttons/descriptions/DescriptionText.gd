extends Label

onready var modData = get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().editor_description.split("\n")

func _ready():
	writeDescription()

func writeDescription():
		
	text = modData[5]

