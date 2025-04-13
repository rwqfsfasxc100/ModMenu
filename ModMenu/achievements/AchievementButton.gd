extends HBoxContainer

var thisAchievement = ""

onready var icon = get_node("VBoxContainer/TextureRect/AchievementIcon")

func handleStat(stat):
	var limit = thisAchievement.split("_")[thisAchievement.split("_").size() - 1]
	if thisAchievement.split("_")[0] == "PLAYTIME":
		limit = int(limit) * 60 * 60
	if limit == 0:
		limit += 1
	icon.max_value = limit
	icon.value = stat[1]
	get_node("Progress").visible = true
	var pLabel = get_node("Progress/Label")
	pLabel.text = pLabel.text % [stat[1], limit]


func doesHaveAssociatedStat():
	var split = thisAchievement.split("_")
	var numerical = false
	if str(split[split.size()-1]).is_valid_integer():
		numerical = true
	if numerical:
		var baseStat = thisAchievement.split("_" + split[split.size()-1])[0]
		var stat = Achivements.achivements.get("stat:" + baseStat)
		return [baseStat, stat]
	else:	
		return false


func _visibility_changed():
	thisAchievement = editor_description
	get_node("ACHNAME/NameLabel").text = TranslationServer.translate("ACHIEVEMENT_" + thisAchievement)
	get_node("ACHNAME/DescLabel").text = TranslationServer.translate("ACHIEVEMENT_" + thisAchievement + "_DESC")
	var stat = doesHaveAssociatedStat()
	if stat:
		handleStat(stat)
	else:
		var ach = Achivements.achivements
		var this = ach.get(thisAchievement)
		if this:
			icon.value = 1
		else:
			icon.value = 0
