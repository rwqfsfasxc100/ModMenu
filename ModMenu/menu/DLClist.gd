extends VBoxContainer

func _ready():
	var dlc = Settings.loadedExtensions
	if Settings.ModMenu["mainSettings"]["displayLocation"] == 0 and dlc.size() >= 1:
		var lb = Label.new()
		lb.text = TranslationServer.translate("MODMENU_DLCLIST_DLCSEPARATOR")
		lb.align = Label.ALIGN_RIGHT
		add_child(lb)
	for d in dlc:
		var meta = Settings.getExtensionManifest(d)
		var l = Label.new()
		l.text = meta.name
		l.align = Label.ALIGN_RIGHT
		add_child(l)
