class_name MenuButtonState extends SizableButton

@export var toState: String

func _on_button_down() -> void:
	button_down()

func _on_button_up() -> void:
	button_up()

func _on_button_pressed() -> void:
	_button_pressed()
