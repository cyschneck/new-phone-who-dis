extends RichTextLabel

# Option Selection on Popup
func _on_button_pressed() -> void:
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]
	var header = contacts_manager.full_contact_right.get_child(1).get_child(1)
	var header_contact_name = header.get_child(1).text
	# remove bold text from string when saving as guess name
	var string_without_bold = (header_contact_name).replace("[b]", "")
	string_without_bold = string_without_bold.replace("[/b]", "")
	var selection_number = self.name
	
	# Update Guess Dictionary
	GameManager.set_guess_dictionary(selection_number, string_without_bold)
	
	# Set New Header Number
	header.get_child(2).text = "[b]" + selection_number + "[/b]"
