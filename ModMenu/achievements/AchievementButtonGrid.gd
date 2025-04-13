extends GridContainer

var thisAchievement = ""

onready var icon = get_node("VBoxContainer/TextureRect/AchievementIcon")

onready var pLabel = get_node("Progress/Label")
func _ready():
	pLabel.visible = false

func handleStat(stat):
	var limit = thisAchievement.split("_")[thisAchievement.split("_").size() - 1]
	if thisAchievement.split("_")[0] == "PLAYTIME":
		limit = int(limit) * 60 * 60
	if int(limit) == int(0):
		limit += 1
	icon.max_value = int(limit)
	icon.value = stat[1]
	pLabel.visible = true
	pLabel.text = "%s \n  / \n%s" % [stat[1], limit]
	

func doesHaveAssociatedStat():
	
	var annoyingAsFuckAchievements = {"DIVER_10":10,"DIVER_50":50,"DIVER_ENCKE":3000,"DIVER_DRAGONS":3005,"DIVER_KEELER":255,"LEAF_2":2000,"LEAF_5":5000,"LEAF_20":20000,"PLAYSTYLE_MANUAL":900}

	var nonObvState = []
	var nonObv = Achivements.statsWithAchievements
	var nonObv2 = Achivements.statsTypeFloat
	for o in nonObv:
		var list = nonObv.get(o)
		for l in list:
			var ac = list.get(l)
			if ac == thisAchievement:
				nonObvState = [ac, o, l]
		
	if thisAchievement in annoyingAsFuckAchievements:
		var title = thisAchievement.split("_")
		var prefix = title[0]
		var suffix = title[1]
		var limit = annoyingAsFuckAchievements.get(thisAchievement)
		var stat = ""
		match prefix:
			"DIVER":
				stat = "maxDepth"
			"LEAF":
				stat = "leaf"
			"PLAYSTYLE":
				stat = "manual"
		var achivData = Achivements.achivements
		var statName = "stat:" + stat
		var statValue = achivData.get(statName)
		return [thisAchievement, int(statValue), limit]
		
		
		
	
	elif nonObvState == []:
		var split = thisAchievement.split("_")
		var numerical = false
		if str(split[split.size()-1]).is_valid_integer():
			numerical = true
		if numerical:
			var baseStat = thisAchievement.split("_" + split[split.size()-1])[0]
			var stat = Achivements.achivements.get("stat:" + baseStat)
			if not stat == null:
				return [baseStat, stat, "NOT_A_RESULT"]
			else:	
				return false
		else:
			return false
	
	else:
		var statP = Achivements.achivements.get("stat:" + nonObvState[1])
		
		return [nonObvState[0], statP, nonObvState[2]]
		


func handleStatMP(stat):
	var limit = stat[2]
	if thisAchievement.split("_")[0] == "PLAYTIME":
		limit = int(limit) * 60 * 60
	if int(limit) == int(0):
		limit += 1
	icon.max_value = int(limit)
	icon.value = stat[1]
	pLabel.visible = true
	pLabel.text = "%s \n  / \n%s" % [stat[1], limit]


func _visibility_changed():
	thisAchievement = editor_description
	get_node("Button/NameLabel").text = TranslationServer.translate("ACHIEVEMENT_" + thisAchievement)
	get_node("DescLabel").text = TranslationServer.translate("ACHIEVEMENT_" + thisAchievement + "_DESC")
	var unob = "res://ModMenu/achievements/achievement_icons/" + thisAchievement + "_L.stex"
	var ob = "res://ModMenu/achievements/achievement_icons/" + thisAchievement + "_U.stex"
	icon.texture_under = load(unob)
	icon.texture_progress = load(ob)
	
	
	
	var stat = doesHaveAssociatedStat()
	if stat:
		if str(stat[2]) == "NOT_A_RESULT":
			handleStat(stat)
		elif not str(stat[2]) == null:
			handleStatMP(stat)
	else:
		var ach = Achivements.achivements
		var this = ach.get(thisAchievement)
		if this:
			icon.value = 1
		else:
			icon.value = 0
	if icon.value < icon.max_value:
		get_node("Button/NameLabel").modulate = "777777"
		get_node("DescLabel").modulate = "777777"
	else:
		get_node("Button/NameLabel").modulate = "ffffff"
		get_node("DescLabel").modulate = "ffffff"
