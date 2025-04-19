extends RichTextLabel

var first_name: String
var last_name: String
var icon_path: String
var description: String
var number: String
var ringtone: String
var recent_calls_dict: Dictionary

const CALL_DESCRIPTION = preload("res://scenes/contacts/call_description.tscn")

# When Contact on Left is Selected
func _on_button_pressed() -> void:
	set_contact()

func set_contact() -> void:
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]

	# if popup still open, close
	contacts_manager.phone_select_popup.visible = false
	
	# Setting up contact name in main panel
	var contact_header = contacts_manager.full_contact_right.get_child(1).get_child(1)
	var header = contact_header.get_child(1)
	header.text = "[b]" + self.name + "[/b]"

	# Setup contact number selected or default
	var guess_num = contacts_manager.return_guess_number(self.name)
	var phone_num = contact_header.get_child(2)
	phone_num.text = "[b]" + guess_num + "[/b]"
	
	# Phone number default
	phone_num["theme_override_colors/default_color"] = Color("#5a5a5a") # Grey
	phone_num.get_child(0).disabled = false
	# set header to white, disable button, if correct
	if self.name in GameManager.correct_and_sync_list:
		phone_num["theme_override_colors/default_color"] = Color("White")
		phone_num.get_child(0).disabled = true


	# Setting up contact description
	var bottom_description = contacts_manager.full_contact_right.get_child(2).get_child(0).get_child(0)
	var contact_description = bottom_description.get_child(0).get_child(1)
	contact_description.text = description
	
	# remove placeholder recent calls
	var recent_calls_datetime = contacts_manager.full_contact_right.get_child(2).get_child(0).get_child(0).get_child(1)
	for call_child in recent_calls_datetime.get_children():
		call_child.queue_free()

	# Setting up Recent Calls
	var recent_calls_header = CALL_DESCRIPTION.instantiate()
	recent_calls_header.text = "[b]Recent Calls:[/b]"
	recent_calls_datetime.add_child(recent_calls_header)

	# Recent call text
	for date in recent_calls_dict.keys():
		var date_description = CALL_DESCRIPTION.instantiate()
		date_description.text = date
		recent_calls_datetime.add_child(date_description)
		var recent_call = CALL_DESCRIPTION.instantiate()
		var call_value = recent_calls_dict[date].split(" ")
		var call_type = call_value[0] + " " + call_value[1]
		var call_length = ""
		if len(call_value) > 2:
			call_length = call_value[-2] + " " + call_value[-1]
		recent_call.text = "\t[b]" + call_type + "[/b] " + call_length
		recent_calls_datetime.add_child(recent_call)

	# Setting up Ringtone
	var ring_tone = bottom_description.get_child(2).get_child(1)
	ring_tone.text = ringtone
