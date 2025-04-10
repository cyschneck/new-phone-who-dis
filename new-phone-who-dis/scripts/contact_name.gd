extends RichTextLabel

var first_name: String
var last_name: String
var icon_path: String
var description: String

func _on_button_pressed() -> void:
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]
	var contact_header = contacts_manager.full_contact_right.get_child(1).get_child(1)
	
	# Setting up contact name in main panel
	contact_header.get_child(1).text = "[b]" + self.text + "[/b]"

	# Setting up contact description
	var bottom_description = contacts_manager.full_contact_right.get_child(2).get_child(0).get_child(0)
	bottom_description.get_child(0).get_child(1).text = description
