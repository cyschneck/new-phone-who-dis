extends RichTextLabel

func _on_popup_message_pressed() -> void:
	# when popup contact is selected
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	if "Unknown" in self.text:
		# reset guess name to contact number
		message_manager.current_contact.reset_guess()
	else:
		# remove bold text from string when saving as guess name
		var string_without_bold = (self.text).replace("[b]", "")
		string_without_bold = string_without_bold.replace("[/b]", "")
		message_manager.current_contact.guess_name = string_without_bold
	# set header to current guess
	message_manager.current_contact.set_messages_header()
