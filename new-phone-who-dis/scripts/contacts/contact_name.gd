extends RichTextLabel

var first_name: String
var last_name: String
var icon_path: String
var description: String
var number: String

# When Contact on Left is Selected
func _on_button_pressed() -> void:
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]

	# if popup still open, close
	contacts_manager.phone_select_popup.visible = false
	
	# Setting up contact name in main panel
	var contact_header = contacts_manager.full_contact_right.get_child(1).get_child(1)
	contact_header.get_child(1).text = "[b]" + self.name + "[/b]"

	# Setup contact number selected or default
	var guess_num = contacts_manager.return_guess_number(self.name)
	contact_header.get_child(2).text = "[b]" + guess_num + "[/b]"

	# Setting up contact description
	var bottom_description = contacts_manager.full_contact_right.get_child(2).get_child(0).get_child(0)
	bottom_description.get_child(0).get_child(1).text = description
