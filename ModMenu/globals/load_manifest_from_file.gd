extends Node

static func load_manifest_from_file(manifest):
	var manifestConfig = {
	"package":{
		"id":null,
		"name":null,
		"version":"unknown",
		"description":"MODMENU_DESCRIPTION_PLACEHOLDER",
		"group":"",
		"github_homepage":"",
		"github_releases":"",
		"discord_thread":"",
		"nexus_page":"",
		"donations_page":"",
		"wiki_page":"",
		"custom_link":"",
		"custom_link_name":"",
		}
	}
	var manifestFile = ConfigFile.new()
	var error = manifestFile.load(manifest)
	if error != OK:
		Debug.l("Mod Menu: Error loading settings %s" % error)
		return 
	for section in manifestConfig:
		for key in manifestConfig[section]:
			manifestConfig[section][key] = manifestFile.get_value(section, key, manifestConfig[section][key])
	return manifestConfig
