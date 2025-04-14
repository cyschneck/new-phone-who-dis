extends CanvasLayer


func _on_close_popup_pressed() -> void:
	# close popup
	get_tree().paused = false
	self.visible = false
