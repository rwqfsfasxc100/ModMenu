extends HTTPRequest

onready var nodeData = get_parent().editor_description

func _ready():
	pass

func _on_FetchRelease_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
