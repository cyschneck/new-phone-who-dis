extends TextureButton

const MESSAGES_SCENE = "res://scenes/_main/messages.tscn"

# "unlock" phone and change scene to messages
func _on_pressed() -> void:
	SceneTransition.change_scene(MESSAGES_SCENE, 1) # SwipeUp
