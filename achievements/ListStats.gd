extends VBoxContainer

var statf = {}

func _ready():
	fetchAchievements()
	for m in statf:
		var sNum = str(statf.get(m))
		sNum = str(formatForLargeNumbers(sNum))
		var label = load("res://ModMenu/achievements/StatLabel.tscn").instance()
		label.name = str(m)
		label.get_node("Label").text = TranslationServer.translate(str(m)) + ": " + sNum
		label.get_node("Label").autowrap = true
		label.get_node("Label").rect_min_size.x = 1080
		label.rect_min_size.y = label.get_node("Label").rect_size.y
		
		add_child(label)
	

func fetchAchievements():
	var list = Achivements.achivements
	for m in list:
		if str(m).begins_with("stat:"):
			if str(m).findn("PLAYTIME") == -1:
				statf.merge({m:list.get(m)})
			else:
				var pm = str(list.get(m)).split(".")[0]
				var pc = int(pm)
				statf.merge({m:pc / 60})

func formatForLargeNumbers(num):
	num = int(num)
	var length = str(num).length()
	if length > 3:
		var concat = []
		var times = length/3
		var offset = length % 3
		var count = 0
		if offset > 0:
			var spl = str(num).substr(0, offset)
			concat.append(spl)
		while times > 0:
			var spl = str(num).substr(offset + (count * 3), 3)
			concat.append(spl)
			count += 1
			times -= 1
		var total = ""
		for m in concat:
			if total == "":
				total = m
			else:
				total = total + "," + m
		return total
	else:
		return num
