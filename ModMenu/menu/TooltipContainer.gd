extends PanelContainer

onready var label = get_node("Label")

onready var margin = get_parent().get_node("MarginContainer")

func _ready():
	visible = false
	margin.margin_top = 6
	margin.margin_bottom = 660
	

func _process(delta):
	var tooltip = get_parent().get_node("MarginContainer/ScrollContainer/Tooltips")
	var text = tooltip.editor_description
	label.text = text
	
	if not margin == null:
		var tooltipData = Settings.ModMenu["mainSettings"]["accessibleTooltips"]
		if tooltipData == 1:
			visible = true
			margin.margin_top = 106
			margin.margin_bottom = 660
			rect_position.y = 6
		elif tooltipData == 2:
			visible = true
			margin.margin_top = 6
			margin.margin_bottom = 560
			rect_position.y = 562
		else:
			visible = false
			margin.margin_bottom = 660
			margin.margin_top = 6
			rect_position.y = 6
