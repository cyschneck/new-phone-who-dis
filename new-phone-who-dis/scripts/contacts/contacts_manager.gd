extends Control

const CONTACT_NAME_PREFAB = preload("res://scenes/contacts/contact_name.tscn")
const POPUP_VALUE = preload("res://scenes/contacts/popup_value.tscn")

@onready var contacts_left_list: Control = %ContactsLeftList
@onready var full_contact_right: Control = %FullContactRight
@onready var phone_select_popup: Control = %PhoneSelectPopup

var contacts_dict: Dictionary

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
	
	var sorted_contacts = GameManager.contact_list_data.keys()
	sorted_contacts.sort() # sort list of strings

	for contact in sorted_contacts:
		var new_contact_name = CONTACT_NAME_PREFAB.instantiate()
		var contact_data = GameManager.contact_list_data[contact]
		
		# setup contacts key
		var dict_key = contact_data["first_name"]
		if contact_data["last_name"] != "":
			dict_key += " " + contact_data["last_name"]
		contacts_dict[dict_key] = ""
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
		
		contact_list.add_child(new_contact_name)
		var add_h_sep = HSeparator.new()
		contact_list.add_child(add_h_sep)

	# setup default contact based on first in list
	set_default_starter(sorted_contacts[0])

func set_default_starter(first_contact: String) -> void:
	# set up the default contact being displayed on start
	var contact_header = full_contact_right.get_child(1).get_child(1).get_child(1)
	var full_name =  GameManager.contact_list_data[first_contact]["first_name"]
	if GameManager.contact_list_data[first_contact]["first_name"] != "":
		full_name += " " + GameManager.contact_list_data[first_contact]["last_name"]
	full_name = "[b]" + full_name + "[/b]"
	contact_header.text = full_name
	
	var description_notes = full_contact_right.get_child(2).get_child(0).get_child(0)
	description_notes.get_child(0).get_child(1).text = GameManager.contact_list_data[first_contact]["description"]


func populate_number_selection() -> void:
	# collect numbers from contact list to populate popup
	var possible_numbers = []
	for contact in GameManager.contact_list_data.keys():
		possible_numbers.append(GameManager.contact_list_data[contact]["number"])
	possible_numbers.sort() # sort numbers

	var popup = phone_select_popup.get_child(1).get_child(0)
	for number in possible_numbers:
		var new_number = POPUP_VALUE.instantiate()
		new_number.name = number
		new_number.text = "[b]" + number + "[/b]"
		popup.add_child(new_number)
		var new_h_sep = HSeparator.new()
		popup.add_child(new_h_sep)

func _on_select_number_pressed() -> void:
	# display popup
	phone_select_popup.visible = true

func _on_close_popup_pressed() -> void:
	phone_select_popup.visible = false
