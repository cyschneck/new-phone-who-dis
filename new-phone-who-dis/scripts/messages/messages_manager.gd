extends Control

@onready var message_field_right: Control = %MessageFieldRight
@onready var contact_message_left: Control = %ContactMessageLeft
const CONTACT_PREFAB = preload("res://scenes/messages/contact_with_last_message.tscn")
const POPUP_MESSAGES_NAME = preload("res://scenes/messages/popup_messages_name.tscn")

@onready var contacts_list: VBoxContainer = %Contacts
@onready var text_messages: VBoxContainer = %TextMessages
@onready var select_contact_popup: Control = %SelectContactPopup

var current_contact

func _ready() -> void:
	# setup game on start based on datafiles
	
	# Clear placeholder text messages
	for message in text_messages.get_children():
		message.queue_free()

	## Clear placeholder contacts
	for contact in contacts_list.get_children():
		contacts_list.remove_child(contact)
		contact.queue_free()
	
	## Clear placeholder popup values
	var remaining_contacts = select_contact_popup.get_child(0).get_child(0).get_child(0)
	for popup_contact in remaining_contacts.get_children():
		popup_contact.queue_free()

	# hide popup
	select_contact_popup.visible = false

	# populate the contacts list with starting values
	populate_contacts_message_list()

	# click on first contact at the start
	var first_contact = contacts_list.get_children()[1]
	current_contact = first_contact
	first_contact.get_child(2).grab_focus() # select first_contact
	first_contact.populate_message_right_field(first_contact.name)
	first_contact.set_messages_header()

# CONTACT LIST (LEFT)
func populate_contacts_message_list() -> void:
	# populate contacts on the left

	# add additional HSeparator to the top of the contacts list
	var top_h_sep = HSeparator.new()
	contacts_list.add_child(top_h_sep)
	
	# organize messages by last received message
	var latest_dates = []
	for contact in GameManager.messages_data.keys():
		var message_dates = GameManager.messages_data[contact]["messages"].keys()
		var last_message = message_dates[-1].split(" ")[0]
		latest_dates.append(last_message)

	# populate contacts on the left field
	for contact in GameManager.messages_data.keys():
		var new_contact = CONTACT_PREFAB.instantiate()
		new_contact.name = contact

		# set the contact_number based on message JSON in GameManager
		new_contact.contact_number = GameManager.correct_name_with_number[GameManager.messages_data[contact]["contact_name"]]

		# set contact name based on current guess
		var contact_name = new_contact.get_child(1).get_child(0).get_child(0).get_child(0)
		var current_guess = "[b]" + GameManager.guess_name_with_number_dict[new_contact.contact_number] + "[/b]"
		contact_name.text = current_guess

		var message = new_contact.get_child(1).get_child(1)
		var message_keys = GameManager.messages_data[contact]["messages"].keys()
		
		var contact_datetime = new_contact.get_child(1).get_child(0).get_child(0).get_child(1)
		var datetime_string = determine_datetime(message_keys[-1])
		contact_datetime.text = datetime_string
	
		# set displayed text to last string of the last text
		var last_message = GameManager.messages_data[contact]["messages"][message_keys[-1]].values()[-1]
		message.text = last_message
	
		# add contact and HSeparator to contact_lists
		contacts_list.add_child(new_contact)
		var new_h_sep = HSeparator.new()
		contacts_list.add_child(new_h_sep)

func determine_datetime(datetime: String) -> String:
	# set displayed datetime to last string of the last text
	var date_time = datetime.split(" ")

	var full_datetime_string = date_time[0]
	# if today, display only time
	if date_time[0] == "5/5/2025":
		full_datetime_string = date_time[2] # Today
	# if yesterday, display yesterday
	if date_time[0] == "5/4/2025":
		full_datetime_string = "Yesterday"
	# if within a week, display weekday
	if date_time[0] in ["5/3/2025", "5/2/2025", "5/1/2025",
						"4/30/2025", "4/29/2025", "4/28/2025"]:
		full_datetime_string = date_time[1]
	return full_datetime_string

## When Header Button is Pressed, open Number Popup
func _on_button_pressed() -> void:
	# when number is selected on header, populate and display popup
	var remaining_contacts = select_contact_popup.get_child(0).get_child(0).get_child(0)

	# remove existing popup values
	for popup_contact in remaining_contacts.get_children():
		popup_contact.queue_free()

	# add default/unknown contact
	var unknown_contact = POPUP_MESSAGES_NAME.instantiate()
	unknown_contact.text = "[b]Unknown[/b]"
	remaining_contacts.add_child(unknown_contact)

	# add new h seperator after default unknown
	var unknown_h_sep = HSeparator.new()
	remaining_contacts.add_child(unknown_h_sep)

	# iteratively add contacts to popup
	for contact in GameManager.sorted_contacts:
		var full_name = GameManager.contact_ordering[contact]
		if full_name not in GameManager.guess_name_with_number_dict.values():
			# if the current guess for a number is unknown, add to popup
			var new_contact = POPUP_MESSAGES_NAME.instantiate()
			new_contact.text = "[b]" + full_name + "[/b]"
		
			remaining_contacts.add_child(new_contact)
			var new_hsep = HSeparator.new()
			remaining_contacts.add_child(new_hsep)

	# display popup
	select_contact_popup.visible = true
