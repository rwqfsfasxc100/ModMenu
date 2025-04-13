extends TextureRect

onready var modData = get_parent().get_parent().editor_description.split("\n")

# Called when the node enters the scene tree for the first time.
func _ready():
	var iconDir = modData[14]
	if not iconDir == "empty":
		self.texture = load(iconDir)
	else:
		self.texture = load("res://ModMenu/menu/icons/missing_icon.png.stex")

