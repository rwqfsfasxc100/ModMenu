extends GridContainer

onready var col = self.columns
onready var separator = preload("res://ModMenu/title/Separator.tscn")
onready var rect = preload("res://ModMenu/title/Rect.tscn")
onready var button = preload("res://ModMenu/title/ButtonBeside.tscn")

func _ready():
	visible = true
	
	
	
	var separatorCount = 0
	while separatorCount < col:
		separatorCount += 1
		var sepint = separator.instance()
		sepint.name = "separator" + str(separatorCount)
		add_child(sepint)
	var rectCount = 1
	while rectCount < col:
		rectCount += 1
		var rectint = rect.instance()
		rectint.name = "rect" + str(rectCount)
		add_child(rectint)
	add_child(button.instance())
	
	
	
#func _physics_process(delta):
#	var hasExtended = Settings.ModMenu["mainSettings"]["extendedSaves"]
#	visible = !hasExtended


func _physics_process(delta):
	var haveTales = Settings.areTalesInstalled()
	if !haveTales:
		get_parent().get_node("Opts/Tales").visible = true
		get_parent().get_node("Opts/Tales").modulate = "070707"
		get_parent().get_node("Opts/Tales").mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_node("SlotE").visible = true
	get_node("NewE").visible = true
