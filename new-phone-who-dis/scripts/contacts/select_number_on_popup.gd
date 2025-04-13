extends RichTextLabel

func _on_button_pressed() -> void:
	var contacts_manager = get_tree().get_nodes_in_group("managers")[0]
	var header = contacts_manager.full_contact_right.get_child(1).get_child(1)
	var header_contact_name = header.get_child(1).text
	contacts_manager.contacts_dict[header_contact_name] = self
	header.get_child(2).text = "[b]" + self.name + "[/b]"
