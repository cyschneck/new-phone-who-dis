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

	# set default number if Unknown
	if number_without_bold == "Unknown":
		number_without_bold = "XXX-XXX-XXXX"
	
	# remove guess from original position
	for number in GameManager.guess_name_with_number_dict.keys():
		if GameManager.guess_name_with_number_dict[number] == header_with_bold:
			GameManager.set_guess_dictionary(number, "")
	# Update Guess Dictionary
	GameManager.set_guess_dictionary(number_without_bold, header_with_bold)
	
	# Set New Header Number
	var header_phone_num = header.get_child(2)
	header_phone_num.text = "[b]" + number_without_bold + "[/b]"
	is_correct_number(header_with_bold)

func is_correct_number(contact_name: String) -> void:
	# check if the current number is guess
	# set header to white, disable button
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]
	if contact_name in GameManager.correct_and_sync_list:
		var contact_header = contacts_manager.full_contact_right.get_child(1).get_child(1)
		var phone_num = contact_header.get_child(2)
		phone_num["theme_override_colors/default_color"] = Color("White")
		phone_num.get_child(0).disabled = true
		# turn off popup
		contacts_manager.phone_select_popup.visible = false
