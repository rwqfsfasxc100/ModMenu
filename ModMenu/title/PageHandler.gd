extends PanelContainer

var hasExtended = false
onready var saves = get_parent().get_parent().get_node("HBoxContainer/Saves")
onready var currentPage = Settings.ModMenu["mainSettings"]["savePage"]
func _ready():
	get_parent().visible = false
	reset()
	


func _process(delta):
	var setExtended = Settings.ModMenu["mainSettings"]["extendedSaves"]
	if not setExtended == null:
		if setExtended:
			
			get_parent().visible = true
			get_child(0).text = TranslationServer.translate("MODMENU_SAVEPAGE") % currentPage
			handleCurrentPage(currentPage)
		else:
			get_parent().visible = false
			reset()

func handleCurrentPage(page):
	if page == 1:
			savePageA(true)
			savePageB(false)
			savePageC(false)
			savePageD(false)
	if page == 2:
			savePageA(false)
			savePageB(true)
			savePageC(false)
			savePageD(false)
	if page == 3:
			savePageA(false)
			savePageB(false)
			savePageC(true)
			savePageD(false)
	if page == 4:
			savePageA(false)
			savePageB(false)
			savePageC(false)
			savePageD(true)

func savePageA(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("A") or save.name.ends_with("B") or save.name.ends_with("C") or save.name.ends_with("D") or save.name.ends_with("E") or save.name.ends_with("F") or save.name.ends_with("G"):
			save.visible = tf


func savePageB(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("H") or save.name.ends_with("I") or save.name.ends_with("J") or save.name.ends_with("K") or save.name.ends_with("L") or save.name.ends_with("M") or save.name.ends_with("N"):
			save.visible = tf


func savePageC(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("O") or save.name.ends_with("P") or save.name.ends_with("Q") or save.name.ends_with("R") or save.name.ends_with("S") or save.name.ends_with("T") or save.name.ends_with("U"):
			save.visible = tf


func savePageD(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("V") or save.name.ends_with("W") or save.name.ends_with("X") or save.name.ends_with("Y") or save.name.ends_with("Z") or save.name.ends_with("One") or save.name.ends_with("Two"):
			save.visible = tf


func reset():
	savePageA(true)
	savePageB(false)
	savePageC(false)
	savePageD(false)


func _on_Next_pressed():
	if currentPage >= 1 and currentPage <= 3:
		currentPage += 1
	else:
		currentPage = 1
	Settings.ModMenu["mainSettings"]["savePage"] = currentPage
	Settings.saveModMenuToFile()

func _on_Prev_pressed():
	if currentPage >= 2 and currentPage <= 4:
		currentPage -= 1
	else:
		currentPage = 4
	Settings.ModMenu["mainSettings"]["savePage"] = currentPage
	Settings.saveModMenuToFile()
