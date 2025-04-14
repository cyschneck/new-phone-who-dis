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
var correct_and_sync: Array = []
const CORRECT_POPUP = preload("res://scenes/manager/correct_popup.tscn")
const CORRECT_GUESS = preload("res://scenes/manager/correct_guess.tscn")

# Store the Contact Number and Associated Guess
# XXX-XXX-XXXX = Guess Full Name
var guess_name_with_number_dict: Dictionary = {}

# Store Contact Name and Contact List ID from contact_data_list
# Full NAME = contact 1
var contact_id_dict: Dictionary = {}

# Store an array of all contacts in sorted order
var sorted_contacts: Array = []
# Stores a contact with its order element and full name
var contact_ordering: Dictionary = {}

func _ready() -> void:
	# Load JSON data
	load_json_data(MESSAGES_JSON)
	load_json_data(CONTACT_LIST_JSON)

	# Store Correct Contact Name and Number
	for contact_key in contact_list_data.keys():
		var full_name =  contact_list_data[contact_key]["first_name"]
		if contact_list_data[contact_key]["last_name"] != "":
			full_name += " " + contact_list_data[contact_key]["last_name"]
		contact_list_data[contact_key]["full_name"] = full_name # add full name to values
		# Full Name = XXX-XXX-XXXX
		correct_name_with_number[full_name] = contact_list_data[contact_key]["number"]
		# Set starting guess for all contacts to contact_number
		# XXX-XXX-XXXX = Guess Full Name
		guess_name_with_number_dict[contact_list_data[contact_key]["number"]] = contact_list_data[contact_key]["number"]
		# Set up reference from contact id and full name
		contact_id_dict[full_name] = contact_key
	
	order_contacts()

## JSON DATA
func load_json_data(file_path: String):
	var data_file = FileAccess.open(file_path, FileAccess.READ)
	var results = JSON.parse_string(data_file.get_as_text())
	if MESSAGES_JSON == file_path:
		messages_data = results
	if CONTACT_LIST_JSON == file_path:
		contact_list_data = results

# Update guessing dictionary
func set_guess_dictionary(contact_number: String, guess: String) -> void:
	# if guess is unknown, set to contact number
	if guess == "":
		guess = contact_number
	guess_name_with_number_dict[contact_number] = guess
	check_for_correct()

# check if three contacts are correct
func check_for_correct() -> void:
	var correct_guesses = 0
	var all_correct = []
	for contact_num in guess_name_with_number_dict.keys():
		if guess_name_with_number_dict[contact_num] != contact_num:
			var guess_full_name = guess_name_with_number_dict[contact_num]
			if correct_name_with_number[guess_full_name] == contact_num:
				if contact_num not in all_correct:
					correct_guesses += 1
					all_correct.append(guess_full_name)

	if correct_guesses == 3:
		# remove existing children
		var correct_popup = CORRECT_POPUP.instantiate()
		var correct_answers_box = correct_popup.get_child(1).get_child(0)
		for child in correct_answers_box.get_children():
			child.queue_free()

		# add header
		var syncing = CORRECT_GUESS.instantiate()
		syncing.text = "[b]" + "CONTACTS SYNCED" + "[/b]"
		correct_answers_box.add_child(syncing)
		var head_hsep = HSeparator.new()
		correct_answers_box.add_child(head_hsep)

		# add correct guesses
		for correct_guess in all_correct:
			correct_and_sync.append(correct_guess)
			var correct_answer = CORRECT_GUESS.instantiate()
			correct_answer.text = "[b]" + correct_guess + " -> " + correct_name_with_number[correct_guess] + "[/b]"
			correct_answers_box.add_child(correct_answer)
			var new_hsep = HSeparator.new()
			correct_answers_box.add_child(new_hsep)

		self.add_child(correct_popup)


func order_contacts() -> void:
	# collect all last names (or first names if no last available)
	for contact_key in contact_list_data.keys():
		var full_name = contact_list_data[contact_key]["full_name"]
		var last_name = contact_list_data[contact_key]["last_name"]
		if last_name != "":
			contact_ordering[last_name] = full_name
		else:
			var first_name = contact_list_data[contact_key]["first_name"]
			contact_ordering[first_name] = full_name
	
	sorted_contacts = contact_ordering.keys()
	sorted_contacts.sort() # sort list of strings
