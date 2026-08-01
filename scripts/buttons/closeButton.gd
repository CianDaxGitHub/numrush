extends SizableButton

@export var polyAudio: AudioStreamPlayer

func _on_button_down() -> void:
	button_down()

func _on_button_up() -> void:
	button_up()

func _on_button_pressed() -> void:
	polyAudio.play_sfx_from_lib("click", 1, -14)
