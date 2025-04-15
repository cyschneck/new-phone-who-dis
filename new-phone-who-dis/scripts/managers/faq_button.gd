extends TextureButton


func _on_pressed() -> void:
	GameManager.display_faq(get_tree().current_scene.name)
