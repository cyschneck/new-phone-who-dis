extends RichTextLabel

func _on_popup_message_pressed() -> void:
	# when popup contact is selected
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	if "Unknown" in self.text:
		message_manager.current_contact.reset_guess()
	else:
		message_manager.current_contact.guess_name = self.text
	message_manager.current_contact.set_messages_header()
