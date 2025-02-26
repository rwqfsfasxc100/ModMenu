extends HTTPRequest

onready var nodeData = get_parent().editor_description

var releaseURL

func _ready():
	pass

func _on_GetAssetDownloadLink_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var releasesContent
	if not json.result == null:
		releasesContent = json.result
	var cycle = 0
	if not releasesContent == null:
		for n in releasesContent:
			if cycle == 0:
				releaseURL = n["browser_download_url"]
				editor_description = n["browser_download_url"]
				cycle += 1
	editor_description = releaseURL
