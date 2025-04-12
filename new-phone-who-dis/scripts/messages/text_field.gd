extends Control

func _ready() -> void:
	var message_manager = get_tree().get_nodes_in_group("managers")[0]
	var text_messages = message_manager.text_messages
	# remove placeholder text
	for child in text_messages.get_children():
		child.queue_free()
