extends HTTPRequest

onready var nodeData = get_parent().editor_description

var assetURL

func _ready():
	pass

func _on_GetLatestValidRelease_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var releasesContent
	if not json.result == null:
		releasesContent = json.result
	var cycle = 0
	if not releasesContent == null:
		for n in releasesContent:
			if not get_parent().checkIfAcceptable(n):
				return
			if cycle == 0:
				assetURL = n["assets_url"]
				editor_description = n["assets_url"]
				cycle += 1
	editor_description = assetURL
