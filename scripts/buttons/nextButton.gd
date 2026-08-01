extends SizableButton

@export var value: int
@export var polyAudio: AudioStreamPlayer

signal questionSwitch(val)


func _on_button_down() -> void:
	button_down()

func _on_button_up() -> void:
	button_up()

func _on_button_pressed() -> void:
	questionSwitch.emit(value)
	polyAudio.play_sfx_from_lib("click", 1, -16)
