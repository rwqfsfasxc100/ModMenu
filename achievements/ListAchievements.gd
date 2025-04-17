extends VBoxContainer

var has = {}
var ach = {}
var statf = {}

var achivements = Achivements.achivements

const achButton = preload("res://ModMenu/achievements/AchievementButtonGrid.tscn")

var rarity = Achivements.achievementRarity

func _ready():
	fetchAchievements()
	var hSize = has.size()
#	var aSize = ach.size()
	var aSize = rarity.size()
	var countLabel = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("MarginContainer2/VBoxContainer/HBoxContainer/HBoxContainer/AchievementCount")
	countLabel.get_node("AnimationPlayer").current_animation = "[stop]"
	countLabel.modulate = "ffffff"
	countLabel.text = "%s / %s" % [hSize, aSize]
	if hSize == aSize:
		countLabel.get_node("AnimationPlayer").current_animation = "Blink"
	makeChildren(has)
	makeChildren(ach)

func fetchAchievements():
	var list = Achivements.achivements
#	var list = achivements
	var pmL = rarity.keys()
	
	
	for m in list:
		var stat = doesHaveAssociatedStat(m)
		if stat:
			var p = handleStat(stat, m)
			if p:
				has.merge({m:list.get(m)})
			else:
				ach.merge({m:list.get(m)})
		else:
			if str(m).begins_with("stat:"):
				statf.merge({m:list.get(m)})
			elif list.get(m):
				has.merge({m:list.get(m)})
			else:
				ach.merge({m:list.get(m)})
	var hKey = has.keys()
	var fmL = []
	if hKey.size() != pmL.size():
		for f in pmL:
			if not hKey.has(f):
				fmL.append(f)
	
		if pmL.size() > 0:
			for t in fmL:
				ach.merge({t:false})
	
	

func makeChildren(dict):
	for s in dict:
		var button = achButton.instance()
		button.name = s
		button.editor_description = s
		add_child(button)
	
	
func doesHaveAssociatedStat(thisAchievement):
	var split = thisAchievement.split("_")
	var numerical = false
	if str(split[split.size()-1]).is_valid_integer():
		numerical = true
	if numerical:
		var baseStat = thisAchievement.split("_" + split[split.size()-1])[0]
		var stat = achivements.get("stat:" + baseStat)
		if not stat == null:
			return [baseStat, stat]
		else:	
			return false
	else:
		return false

func handleStat(stat, thisAchievement):
	var limit = thisAchievement.split("_")[thisAchievement.split("_").size() - 1]
	if thisAchievement.split("_")[0] == "PLAYTIME":
		limit = int(limit) * 60 * 60
	if int(limit) == int(0):
		limit += 1
	var maximum = int(limit)
	var value = stat[1]
	if value < maximum:
		return false
	else:
		return true
