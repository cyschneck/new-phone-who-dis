extends Control

const BASE_MESSAGES_JSON = "res://data/base_messages.json"
var base_messages_data: Dictionary = {} # JSON data for each button

@onready var contact_message_left: Control = %ContactMessageLeft
const CONTACT_PREFAB = preload("res://scenes/contact_with_last_message.tscn")

func _ready() -> void:
	# setup game on start based on datafiles
	
	## LOAD DATA
	load_json_data(BASE_MESSAGES_JSON)
	
	## Clear placeholder contacts
	var contacts = contact_message_left.get_child(1).get_child(0)
	for contact in contacts.get_children():
		contact.queue_free()

	# populate the contacts list with starting values
	populate_contacts_message_list()

func populate_contacts_message_list() -> void:
	var contacts = contact_message_left.get_child(1).get_child(0)
	for contact in base_messages_data.keys():
		var new_contact = CONTACT_PREFAB.instantiate()
		var contact_name = new_contact.get_child(1).get_child(0).get_child(0).get_child(0)
		contact_name.text = base_messages_data[contact]["number"]
		new_contact.name =  base_messages_data[contact]["number"]
		var message = new_contact.get_child(1).get_child(1)
		var message_keys = base_messages_data[contact]["messages"].keys()
		var last_message = message_keys[-1]
		message.text = base_messages_data[contact]["messages"][last_message]
		
		contacts.add_child(new_contact)
		var new_h_sep = HSeparator.new()
		contacts.add_child(new_h_sep)

## JSON DATA
func load_json_data(file_path: String):
	var data_file = FileAccess.open(file_path, FileAccess.READ)
	var results = JSON.parse_string(data_file.get_as_text())
	base_messages_data = results
