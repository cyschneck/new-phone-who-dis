extends Control

const CONTACT_NAME_PREFAB = preload("res://scenes/contacts/contact_name.tscn")
const POPUP_VALUE = preload("res://scenes/contacts/popup_value.tscn")

@onready var contacts_left_list: Control = %ContactsLeftList
@onready var full_contact_right: Control = %FullContactRight
@onready var phone_select_popup: Control = %PhoneSelectPopup

func _ready() -> void:
	## Clear placeholder contacts
	var contacts = contacts_left_list.get_child(1).get_child(0)
	for contact in contacts.get_children():
		contact.queue_free()

	# populate the contacts list with starting values
	populate_contacts_list()
	
	# hide popup on start
	var popup_phone_numbers = phone_select_popup.get_child(1).get_child(0)
	for number in popup_phone_numbers.get_children():
		number.queue_free()
	phone_select_popup.visible = false
	populate_number_selection()

func populate_contacts_list() -> void:
	var contact_list = contacts_left_list.get_child(1).get_child(0)
	var new_h_sep = HSeparator.new() # start contact list with a seperator
	contact_list.add_child(new_h_sep)

	# Display contacts in order
	var first_contact
	for contact in GameManager.sorted_contacts:
		var new_contact_name = CONTACT_NAME_PREFAB.instantiate()
		var contact_full_name = GameManager.contact_ordering[contact]
		var contact_data = GameManager.contact_list_data[GameManager.contact_id_dict[contact_full_name]]
		
		# setup contacts key
		var dict_key = contact_data["first_name"]
		if contact_data["last_name"] != "":
			dict_key += " " + contact_data["last_name"]
		new_contact_name.name = dict_key

		# setup bolded text on contacts
		var full_name = "  " + contact_data["first_name"]
		# add bold around part of name used for sorting
		if contact_data["last_name"] != "":
			full_name += " [b]" + contact_data["last_name"] + "[/b]"
		else:
			full_name = "[b]" + full_name + "[/b]"
		new_contact_name.text = full_name
		new_contact_name.first_name = contact_data["first_name"]
		new_contact_name.last_name = contact_data["last_name"]
		new_contact_name.icon_path = contact_data["icon"]
		new_contact_name.description = contact_data["description"]
		new_contact_name.number = contact_data["number"]
		new_contact_name.ringtone = contact_data["ringtone"]
		new_contact_name.recent_calls_dict = contact_data["recent_calls"]
		
		contact_list.add_child(new_contact_name)
		var add_h_sep = HSeparator.new()
		contact_list.add_child(add_h_sep)
		
		if contact == GameManager.sorted_contacts[0]:
			# setup default contact based on first in list
			first_contact = new_contact_name

	# select first contact
	first_contact.set_contact()

func return_guess_number(contact_name: String) -> String:
	var guess_number = "XXX-XXX-XXXX" # default
	# set contact number based on guess
	for contact_number in GameManager.guess_name_with_number_dict.keys():
		if GameManager.guess_name_with_number_dict[contact_number] == contact_name:
			guess_number = contact_number
	return guess_number

func populate_number_selection() -> void:
	var popup = phone_select_popup.get_child(1).get_child(0)
	# Clear existing popup values
	for number in popup.get_children():
		number.queue_free()

	# collect numbers from contact list to populate popup
	var possible_numbers = []
	for contact in GameManager.contact_list_data.keys():
		possible_numbers.append(GameManager.contact_list_data[contact]["number"])
	possible_numbers.sort() # sort numbers

	# add default/unknown contact
	var unknown_contact = POPUP_VALUE.instantiate()
	unknown_contact.text = "[b]Unknown[/b]"
	popup.add_child(unknown_contact)

	# add new h seperator after default unknown
	var unknown_h_sep = HSeparator.new()
	popup.add_child(unknown_h_sep)

	for number in possible_numbers:
		if GameManager.guess_name_with_number_dict[number] == number:
			# if the guess number is still available, not assigned to a name
			var new_number = POPUP_VALUE.instantiate()
			new_number.name = number
			new_number.text = "[b]" + number + "[/b]"
			popup.add_child(new_number)
	
			var new_h_sep = HSeparator.new()
			popup.add_child(new_h_sep)

func _on_select_number_pressed() -> void:
	# display popup
	populate_number_selection()
	phone_select_popup.visible = true

func _on_close_popup_pressed() -> void:
	phone_select_popup.visible = false
