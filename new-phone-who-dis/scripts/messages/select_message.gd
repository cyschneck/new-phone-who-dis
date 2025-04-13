extends Control

# save contact number
var contact_number = ""

const CALLER_GREEN_TEXT = preload("res://scenes/messages/caller_green_text.tscn")
const SENDER_PURPLE_TEXT = preload("res://scenes/messages/sender_purple_text.tscn")

func _on_button_pressed() -> void:
	# select a contact on the left field
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	
	# set current message field to current
	message_manager.current_contact = self
	populate_message_right_field(self.name)
	
	# if popup is visible, close popup
	message_manager.select_contact_popup.visible = false

func populate_message_right_field(contact: String) -> void:
	# set header
	set_messages_header()

	# populate the message field when a contact message is selected
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	var contact_messages = GameManager.messages_data[contact]["messages"]
	var text_messages_field = message_manager.text_messages
	
	# remove existing text messages
	for existing_text_messages in text_messages_field.get_children():
		existing_text_messages.queue_free()

	for message_origin in contact_messages.keys():
		var new_split_text_message = split_message(contact_messages[message_origin])
		
		# create new text message with prefab
		if "sender" in message_origin:
			var new_sender_text = SENDER_PURPLE_TEXT.instantiate()
			new_sender_text.text = new_split_text_message
			text_messages_field.add_child(new_sender_text)
		elif "caller" in message_origin:
			var new_caller_text = CALLER_GREEN_TEXT.instantiate()
			new_caller_text.text = new_split_text_message
			text_messages_field.add_child(new_caller_text)

func set_messages_header() -> void:
	# set the header based on contact name
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	var current_guess = GameManager.guess_name_with_number_dict[contact_number]
	current_guess = "[b]" + current_guess + "[/b]"

	# set main header
	var header = message_manager.message_field_right.get_child(1).get_child(0)
	header.text = current_guess

	# set contact field on left
	var contact_field = self.get_child(1).get_child(0).get_child(0).get_child(0)
	contact_field.text = current_guess

func split_message(full_message: String) -> String:
	# split text after XX characters, but without splitting up a word
	var full_length = 0
	var current_index = 0
	var last_space_index = 0
	var new_split_text = ""

	for character in full_message:
		if current_index >= 50:
			# add a newline character at last space
			new_split_text[last_space_index] = "\n"
			current_index = 0
		else:
			if character == " ":
				last_space_index = full_length
		new_split_text += character
		full_length += 1
		current_index += 1
	return new_split_text
