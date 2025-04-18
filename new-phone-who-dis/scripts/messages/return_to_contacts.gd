extends TextureButton

const CONTACTS_SCENE = "res://scenes/_main/contacts.tscn"

func _on_pressed() -> void:
	# transition to contacts scene
	SceneTransition.change_scene(CONTACTS_SCENE, 2)
