extends Node

# Game/Scene Manager to save between scenes

# Store message data from JSON
const MESSAGES_JSON = "res://data/messages.json"
var messages_data: Dictionary = {} # JSON data for each button

const CONTACT_LIST_JSON = "res://data/contact_list.json"
var contact_list_data: Dictionary = {} # JSON data for contact

# Store Correct Contact Name and Number
var correct_name_with_number: Dictionary = {}

func _ready() -> void:
	# Load JSON data
	load_json_data(MESSAGES_JSON)
	load_json_data(CONTACT_LIST_JSON)

## JSON DATA
func load_json_data(file_path: String):
	var data_file = FileAccess.open(file_path, FileAccess.READ)
	var results = JSON.parse_string(data_file.get_as_text())
	if MESSAGES_JSON == file_path:
		messages_data = results
	if CONTACT_LIST_JSON == file_path:
		contact_list_data = results

# Store the Contact Number and Associated Guess
var guess_name_with_number_dict: Dictionary = {}

func set_guess_dictionary(contact_number: String, guess: String) -> void:
	guess_name_with_number_dict[guess] = contact_number
