extends Node

# Game/Scene Manager to save between scenes

# FAQ
const FAQ_POPUP = preload("res://scenes/manager/faq_popup.tscn")

# Store message data from JSON
const MESSAGES_JSON = "res://data/messages.json"
var messages_data: Dictionary = {} # JSON data for each button

const CONTACT_LIST_JSON = "res://data/contact_list.json"
var contact_list_data: Dictionary = {} # JSON data for contact

# Store Correct Contact Name and Number
# Full Name = XXX-XXX-XXXX
var correct_name_with_number: Dictionary = {}
var correct_and_sync_list: Array = []
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

# END GAME
const NEW_MESSAGE_ALERT = preload("res://scenes/manager/new_message_alert.tscn")

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
	var correct_guesses = []
	for contact_num in guess_name_with_number_dict.keys():
		if guess_name_with_number_dict[contact_num] != contact_num:
			var guess_full_name = guess_name_with_number_dict[contact_num]
			if correct_name_with_number[guess_full_name] == contact_num:
				if guess_full_name not in correct_and_sync_list:
					# only add contacts not already synced
					correct_guesses.append(guess_full_name)

	if len(correct_guesses) == 2:
		# remove existing children
		var correct_popup = CORRECT_POPUP.instantiate()
		var correct_answers_box = correct_popup.get_child(1).get_child(1).get_child(0)
		for child in correct_answers_box.get_children():
			child.queue_free()

		# add header
		var syncing = CORRECT_GUESS.instantiate()
		syncing.text = "[b]" + "CONTACTS SYNCED" + "[/b]"
		correct_answers_box.add_child(syncing)
		var head_hsep = HSeparator.new()
		correct_answers_box.add_child(head_hsep)

		# add correct guesses
		for correct_guess in correct_guesses:
			correct_and_sync_list.append(correct_guess)
			var correct_answer = CORRECT_GUESS.instantiate()
			correct_answer.text = "[b]" + correct_guess + " -> " + correct_name_with_number[correct_guess] + "[/b]"
			correct_answers_box.add_child(correct_answer)
			var new_hsep = HSeparator.new()
			correct_answers_box.add_child(new_hsep)

		self.add_child(correct_popup)
		get_tree().paused = true

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

func display_faq(scene_name: String) -> void:
	# display FAQ with scene specific details
	get_tree().paused = true
	var faq_popup = FAQ_POPUP.instantiate()
	if scene_name == "messages":
		faq_popup.get_child(2).visible = true
		faq_popup.get_child(3).visible = false
	if scene_name == "contacts":
		faq_popup.get_child(2).visible = false
		faq_popup.get_child(3).visible = true
	self.add_child(faq_popup)

func display_new_message_alert() -> void:
	# display end game message
	var new_message_popup = NEW_MESSAGE_ALERT.instantiate()
	get_tree().paused = true
	self.add_child(new_message_popup)

func trigger_end_game() -> void:
	# trigger end game
	if get_tree().current_scene.name == "contacts":
		# transition to main messages
		const MESSAGES_SCENE = "res://scenes/_main/messages.tscn"
		SceneTransition.change_scene(MESSAGES_SCENE, 3)
		await get_tree().create_timer(0.1).timeout # wait for scene to transition
	
	# display end credits
	set_guess_dictionary("555-555-5555", "End Credits")
	correct_and_sync_list.append("End Credits")
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	message_manager.contacts_list.get_child(0).visible = true
	message_manager.contacts_list.get_child(1).visible = true
	message_manager.focus_on_first_element(1)
