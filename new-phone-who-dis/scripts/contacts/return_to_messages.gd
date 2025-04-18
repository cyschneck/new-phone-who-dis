extends TextureButton

const MESSAGES_SCENE = "res://scenes/_main/messages.tscn"

func _on_pressed() -> void:
	# return to main messages scene
	SceneTransition.change_scene(MESSAGES_SCENE, 3)
