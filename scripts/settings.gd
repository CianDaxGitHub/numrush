extends Control


var bgm: bool = true
var sfx: bool = true

signal logOut

func _ready() -> void:
	$AnimationPlayer.play("on_enter")

func _on_btn_back_pressed() -> void:
	$AnimationPlayer.play("on_exit")

func _on_btn_music_pressed() -> void:
	bgm = not bgm
	AudioServer.set_bus_mute(AudioServer.get_bus_index("bgm"), not bgm)

func _on_btn_sound_pressed() -> void:
	sfx = not sfx
	AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), not sfx)

func _on_btn_acc_pressed() -> void:
	$AnimationPlayer.play("enter_logout")

func _on_btn_quit_pressed() -> void:
	get_tree().quit()

func _on_btn_no_pressed() -> void:
	$AnimationPlayer.play("exit_logout")

func _on_btn_yes_pressed() -> void:
	%btnNo.disabled = true
	%btnNo.modulate =  Color(0.5, 0.5, 0.5)
	%btnYes.disabled = true
	%btnYes.modulate =  Color(0.5, 0.5, 0.5)
	
	logOut.connect(get_tree().current_scene._on_logout)
	logOut.emit()
	logOut.disconnect(get_tree().current_scene._on_logout)
