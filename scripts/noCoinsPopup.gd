extends Control

func _on_button_yes_pressed() -> void:
	$AnimationPlayer.play("exit_scene")
