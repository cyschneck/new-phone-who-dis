extends TextureButton

const MESSAGES_SCENE = "res://scenes/_main/messages.tscn"

# "unlock" phone and change scene to messages
func _on_pressed() -> void:
	get_tree().change_scene_to_file(MESSAGES_SCENE)
