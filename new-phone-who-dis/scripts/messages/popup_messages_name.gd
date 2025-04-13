extends RichTextLabel

func _on_popup_message_pressed() -> void:
	# when popup contact is selected
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	if "Unknown" in self.text:
		# reset guess name to unknown
		GameManager.set_guess_dictionary(message_manager.current_contact.contact_number, "")
	else:
		# remove bold text from string when saving as guess name
		var string_without_bold = (self.text).replace("[b]", "")
		string_without_bold = string_without_bold.replace("[/b]", "")
		GameManager.set_guess_dictionary(message_manager.current_contact.contact_number,
										string_without_bold)
	# set header to current guess
	message_manager.current_contact.set_messages_header()
