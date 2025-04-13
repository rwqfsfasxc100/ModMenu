extends PanelContainer

var hasExtended = false
onready var saves = get_parent().get_parent().get_node("HBoxContainer/Saves")
onready var opts = get_parent().get_parent().get_node("HBoxContainer/Opts")
onready var currentPage = Settings.ModMenu["mainSettings"]["savePage"]
onready var sPage = 1
func _ready():
	self.visible = false
	get_parent().get_node("Next").visible = false
	get_parent().get_node("Prev").visible = false
	
	get_parent().get_node("Next2").visible = false
	get_parent().get_node("Page2").visible = false
	get_parent().get_node("Prev2").visible = false
	reset()
	


func _process(delta):
	var reduceClutter = Settings.ModMenu["mainSettings"]["reduceTitleClutter"]
	if not reduceClutter == null:
		if reduceClutter:
			get_parent().get_node("Next2").visible = true
			get_parent().get_node("Page2").visible = true
			get_parent().get_node("Prev2").visible = true
			get_parent().get_node("Page2/Label").text = TranslationServer.translate("MM_SAVEPAGE") % sPage
			handleSettingsPage(sPage)
		else:
			get_parent().get_node("Next2").visible = false
			get_parent().get_node("Page2").visible = false
			get_parent().get_node("Prev2").visible = false
			handleSettingsPage(69)
			reset()
	
	
	
	var setExtended = Settings.ModMenu["mainSettings"]["extendedSaves"]
	if not setExtended == null:
		if setExtended:
			self.visible = true
			get_parent().get_node("Next").visible = true
			get_parent().get_node("Prev").visible = true
			get_child(0).text = TranslationServer.translate("MM_SAVEPAGE") % currentPage
			handleCurrentPage(currentPage)
		else:
			self.visible = false
			get_parent().get_node("Next").visible = false
			get_parent().get_node("Prev").visible = false
			handleCurrentPage(1)
			reset()
	

func handleSettingsPage(page):
	if page == 1:
			settingsPageA(true)
			settingsPageB(false)
	if page == 2:
			settingsPageA(false)
			settingsPageB(true)
	if page == 69:
		settingsPageA(true)
		settingsPageB(true)

func settingsPageA(state):
	for save in opts.get_children():
		var saveName = save.name
		if save.name == "Settings" or save.name == "Achievements" or save.name == "Exit" or save.name == "Credits":
			save.visible = state
func settingsPageB(state):
	for save in opts.get_children():
		var saveName = save.name
		if save.name == "Youtube" or save.name == "Community" or save.name == "Tales" or save.name == "Roadmap":
			save.visible = state


func handleCurrentPage(page):
	
	var reduceClutter = Settings.ModMenu["mainSettings"]["reduceTitleClutter"]
	if not reduceClutter:
		if page == 1:
				savePageA(true)
				savePageB(false)
				savePageC(false)
				savePageD(false)
				savePageAA(true)
				savePageBB(false)
				savePageCC(false)
				savePageDD(false)
		if page == 2:
				savePageA(false)
				savePageB(true)
				savePageC(false)
				savePageD(false)
				savePageAA(false)
				savePageBB(true)
				savePageCC(false)
				savePageDD(false)
		if page == 3:
				savePageA(false)
				savePageB(false)
				savePageC(true)
				savePageD(false)
				savePageAA(false)
				savePageBB(false)
				savePageCC(true)
				savePageDD(false)
		if page == 4:
				savePageAA(false)
				savePageBB(false)
				savePageCC(false)
				savePageDD(true)
				savePageA(false)
				savePageB(false)
				savePageC(false)
				savePageD(true)
	else:
		if page == 1:
				savePageA(true)
				savePageB(false)
				savePageC(false)
				savePageD(false)
				savePageAA(false)
				savePageBB(false)
				savePageCC(false)
				savePageDD(false)
		if page == 2:
				savePageA(false)
				savePageB(false)
				savePageC(false)
				savePageD(false)
				savePageAA(true)
				savePageBB(false)
				savePageCC(false)
				savePageDD(false)
		if page == 3:
				savePageA(false)
				savePageB(true)
				savePageC(false)
				savePageD(false)
				savePageAA(false)
				savePageBB(false)
				savePageCC(false)
				savePageDD(false)
		if page == 4:
				savePageAA(false)
				savePageBB(true)
				savePageCC(false)
				savePageDD(false)
				savePageA(false)
				savePageB(false)
				savePageC(false)
				savePageD(false)
	
		if page == 5:
				savePageA(false)
				savePageB(false)
				savePageC(true)
				savePageD(false)
				savePageAA(false)
				savePageBB(false)
				savePageCC(false)
				savePageDD(false)
		if page == 6:
				savePageA(false)
				savePageB(false)
				savePageC(false)
				savePageD(false)
				savePageAA(false)
				savePageBB(false)
				savePageCC(true)
				savePageDD(false)
		if page == 7:
				savePageA(false)
				savePageB(false)
				savePageC(false)
				savePageD(true)
				savePageAA(false)
				savePageBB(false)
				savePageCC(false)
				savePageDD(false)
		if page == 8:
				savePageAA(false)
				savePageBB(false)
				savePageCC(false)
				savePageDD(true)
				savePageA(false)
				savePageB(false)
				savePageC(false)
				savePageD(false)
	
	
	
func savePageA(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("A") or save.name.ends_with("B") or save.name.ends_with("C") or save.name.ends_with("D"):
			save.visible = tf


func savePageB(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("I") or save.name.ends_with("J") or save.name.ends_with("K") or save.name.ends_with("L"):
			save.visible = tf


func savePageC(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("Q") or save.name.ends_with("R") or save.name.ends_with("S") or save.name.ends_with("T"):
			save.visible = tf


func savePageD(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("Y") or save.name.ends_with("Z") or save.name.ends_with("One") or save.name.ends_with("Two"):
			save.visible = tf
func savePageAA(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("E") or save.name.ends_with("F") or save.name.ends_with("G") or save.name.ends_with("H"):
			save.visible = tf


func savePageBB(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("M") or save.name.ends_with("N") or save.name.ends_with("O") or save.name.ends_with("P"):
			save.visible = tf


func savePageCC(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("U") or save.name.ends_with("V") or save.name.ends_with("W") or save.name.ends_with("X"):
			save.visible = tf


func savePageDD(tf):
	for save in saves.get_children():
		var saveName = save.name
		if save.name.ends_with("Three") or save.name.ends_with("Four") or save.name.ends_with("Five") or save.name.ends_with("Six"):
			save.visible = tf


func reset():
	savePageA(true)
	savePageB(false)
	savePageC(false)
	savePageD(false)


func _on_NextOpt_pressed():
	if sPage == 1:
		sPage += 1
	else:
		sPage = 1

func _on_PrevOpt_pressed():
	if sPage == 2:
		sPage -= 1
	else:
		sPage = 2


func _on_Next_pressed():
	
	var reduceClutter = Settings.ModMenu["mainSettings"]["reduceTitleClutter"]
	if not reduceClutter:
			
		if currentPage >= 1 and currentPage <= 3:
			currentPage += 1
		else:
			currentPage = 1
	else:
			
		if currentPage >= 1 and currentPage <= 7:
			currentPage += 1
		else:
			currentPage = 1
	Settings.ModMenu["mainSettings"]["savePage"] = currentPage
	Settings.saveModMenuToFile()

func _on_Prev_pressed():
	
	var reduceClutter = Settings.ModMenu["mainSettings"]["reduceTitleClutter"]
	if not reduceClutter:
			
		if currentPage >= 2 and currentPage <= 4:
			currentPage -= 1
		else:
			currentPage = 4
	else:
		
		if currentPage >= 2 and currentPage <= 8:
			currentPage -= 1
		else:
			currentPage = 8
	Settings.ModMenu["mainSettings"]["savePage"] = currentPage
	Settings.saveModMenuToFile()
