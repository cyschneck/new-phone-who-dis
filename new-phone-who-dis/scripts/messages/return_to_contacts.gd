extends TextureButton

const CONTACTS_SCENE = "res://scenes/_main/contacts.tscn"

func _on_pressed() -> void:
	# transition to contacts scene
	get_tree().change_scene_to_file(CONTACTS_SCENE)
