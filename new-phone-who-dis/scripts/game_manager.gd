extends Node

# Game/Scene Manager to save between scenes

# Store message data from JSON
const MESSAGES_JSON = "res://data/messages.json"
var messages_data: Dictionary = {} # JSON data for each button

const CONTACT_LIST_JSON = "res://data/contact_list.json"
var contact_list_data: Dictionary = {} # JSON data for contact

# Store Correct Contact Name and Number
# Full Name = XXX-XXX-XXXX
var correct_name_with_number: Dictionary = {}

# Store the Contact Number and Associated Guess
# XXX-XXX-XXXX = Guess Full Name
var guess_name_with_number_dict: Dictionary = {}

func _ready() -> void:
	# Load JSON data
	load_json_data(MESSAGES_JSON)
	load_json_data(CONTACT_LIST_JSON)
	
	# Store Correct Contact Name and Number
	for contact_key in contact_list_data.keys():
		var full_name =  contact_list_data[contact_key]["first_name"]
		if contact_list_data[contact_key]["last_name"] != "":
			full_name += " " + contact_list_data[contact_key]["last_name"]
		correct_name_with_number[full_name] = contact_list_data[contact_key]["number"]
	
	# Set starting guess for all contacts to contact_number
	for message_key in messages_data.keys():
		var act_contact_name = messages_data[message_key]["contact_name"]
		var contact_number = correct_name_with_number[act_contact_name]
		guess_name_with_number_dict[contact_number] = contact_number

## JSON DATA
func load_json_data(file_path: String):
	var data_file = FileAccess.open(file_path, FileAccess.READ)
	var results = JSON.parse_string(data_file.get_as_text())
	if MESSAGES_JSON == file_path:
		messages_data = results
	if CONTACT_LIST_JSON == file_path:
		contact_list_data = results

func set_guess_dictionary(contact_number: String, guess: String) -> void:
	# if guess is unknown, set to contact number
	if guess == "":
		guess = contact_number
	guess_name_with_number_dict[contact_number] = guess
