extends SizableButton


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		button_down()
	else:
		button_up()
