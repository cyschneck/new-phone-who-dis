extends RichTextLabel

# Option Selection on Popup
func _on_button_pressed() -> void:
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]
	var header = contacts_manager.full_contact_right.get_child(1).get_child(1)
	var header_contact_name = header.get_child(1).text
	# remove bold text from string when saving
	var header_with_bold = (header_contact_name).replace("[b]", "")
	header_with_bold = header_with_bold.replace("[/b]", "")
	var number_without_bold = (self.text).replace("[b]", "")
	number_without_bold = number_without_bold.replace("[/b]", "")

	if number_without_bold == "Unknown":
		number_without_bold = "XXX-XXX-XXXX"
	
	# remove guess from original position
	for number in GameManager.guess_name_with_number_dict.keys():
		if GameManager.guess_name_with_number_dict[number] == header_with_bold:
			GameManager.set_guess_dictionary(number, "")
	# Update Guess Dictionary
	GameManager.set_guess_dictionary(number_without_bold, header_with_bold)
	
	# Set New Header Number
	header.get_child(2).text = "[b]" + number_without_bold + "[/b]"
