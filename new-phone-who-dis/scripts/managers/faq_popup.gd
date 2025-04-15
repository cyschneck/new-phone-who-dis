extends CanvasLayer


func _on_close_popup_pressed() -> void:
	get_tree().paused = false
	self.queue_free() # delete self
