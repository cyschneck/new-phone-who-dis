extends CanvasLayer


func _on_button_pressed() -> void:
	get_tree().paused = false
	self.queue_free() # delete self
	GameManager.trigger_end_game()
