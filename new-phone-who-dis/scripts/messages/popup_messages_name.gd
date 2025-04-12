extends RichTextLabel

func _on_button_pressed() -> void:
	# when contact name is selected, replace header with new value
	var messages_manager = get_tree().get_nodes_in_group("managers")[0]
	messages_manager.set_messages_header(self.text)
