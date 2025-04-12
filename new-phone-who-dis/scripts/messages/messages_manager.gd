extends Control

const MESSAGES_JSON = "res://data/messages.json"
var messages_data: Dictionary = {} # JSON data for each button

@onready var message_field_right: Control = %MessageFieldRight
@onready var contact_message_left: Control = %ContactMessageLeft
const CONTACT_PREFAB = preload("res://scenes/messages/contact_with_last_message.tscn")
const POPUP_MESSAGES_NAME = preload("res://scenes/messages/popup_messages_name.tscn")

@onready var contacts_list: VBoxContainer = %Contacts
@onready var text_messages: VBoxContainer = %TextMessages
@onready var select_contact_popup: Control = %SelectContactPopup

var current_contact
var message_dict: Dictionary

func _ready() -> void:
	# setup game on start based on datafiles
	
	## LOAD DATA
	load_json_data(MESSAGES_JSON)

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
	
func populate_contacts_message_list() -> void:
	var top_h_sep = HSeparator.new()
	contacts_list.add_child(top_h_sep)
	for contact in messages_data.keys():
		var new_contact = CONTACT_PREFAB.instantiate()
		new_contact.name = contact
		new_contact.guess_name = messages_data[contact]["number"]
		
		# track contact number with current guess
		message_dict[messages_data[contact]["number"]] = new_contact.guess_name
		
		# set contact variables
		var contact_name = new_contact.get_child(1).get_child(0).get_child(0).get_child(0)
		new_contact.contact_name = messages_data[contact]["contact_name"]
		new_contact.contact_number = messages_data[contact]["number"]
	
		# set contact name (default)
		contact_name.text = messages_data[contact]["number"]
		
		# set displayed text to last string of the last text
		var message = new_contact.get_child(1).get_child(1)
		var message_keys = messages_data[contact]["messages"].keys()
		var last_message = message_keys[-1]
		message.text = messages_data[contact]["messages"][last_message]
		
		contacts_list.add_child(new_contact)
		var new_h_sep = HSeparator.new()
		contacts_list.add_child(new_h_sep)

## JSON DATA
func load_json_data(file_path: String):
	var data_file = FileAccess.open(file_path, FileAccess.READ)
	var results = JSON.parse_string(data_file.get_as_text())
	messages_data = results

func _on_button_pressed() -> void:
	# display Popup
	select_contact_popup.visible = true
	
	# populate with remaining contacts
	var remaining_contacts = select_contact_popup.get_child(0).get_child(0).get_child(0)
	# add unknown contact
	var unknown_contact = POPUP_MESSAGES_NAME.instantiate()
	unknown_contact.text = "[b]Unknown[/b]"
	remaining_contacts.add_child(unknown_contact)
	# add new h seperator
	var unknown_h_sep = HSeparator.new()
	remaining_contacts.add_child(unknown_h_sep)
	for contact_value in messages_data.keys():
		var new_contact = POPUP_MESSAGES_NAME.instantiate()
		new_contact.text = "[b]" + messages_data[contact_value]["contact_name"] + "[/b]"
		remaining_contacts.add_child(new_contact)
		var new_hsep = HSeparator.new()
		remaining_contacts.add_child(new_hsep)
