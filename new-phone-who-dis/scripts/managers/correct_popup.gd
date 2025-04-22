extends CanvasLayer

func _on_close_popup_pressed() -> void:
	# close popup
	get_tree().paused = false
	self.queue_free() # delete self

	if len(GameManager.correct_and_sync_list) == len(GameManager.contact_list_data.keys()) - 1:
		GameManager.display_new_message_alert()
