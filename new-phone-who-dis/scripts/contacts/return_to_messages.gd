extends TextureButton

const MESSAGES_SCENE = "res://scenes/_main/messages.tscn"

func _on_pressed() -> void:
	# return to main messages scene
	get_tree().change_scene_to_file(MESSAGES_SCENE)
