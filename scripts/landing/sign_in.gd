extends Control

@onready var username_input = %Username
@onready var password_input = %Password

@onready var done_button = %Done
@onready var back_button = %btnBack
@onready var username_instruction = %userInst

var tween: Tween

signal login

func _ready():
	username_input.gui_input.connect(func (event: InputEvent): _input_glow(event, username_input))
	password_input.gui_input.connect(func (event: InputEvent): _input_glow(event, password_input))
	_validate_form()

func _input_glow(event: InputEvent, node: Control):
	if event is InputEventScreenTouch:
		if event.pressed:
			if tween: tween.kill()
			tween = create_tween().set_trans(Tween.TRANS_SINE)
			tween.tween_property(node, "self_modulate", Color(0.8, 0.8, 1), 0.2)
			tween.tween_property(node, "self_modulate", Color(1, 1, 1), 0.4)

func _validate_form(_text: String = ""):
	var is_valid = not username_input.text.is_empty() and not password_input.text.is_empty()
	
	done_button.disabled = not is_valid
	
	if is_valid:
		done_button.modulate = Color(1, 1, 1)
		done_button.get_child(0).modulate = Color(1, 1, 1)
	else:
		done_button.modulate = Color(0.7, 0.7, 0.7)
		done_button.get_child(0).modulate = Color(0.7, 0.7, 0.7)

func _on_done_pressed():
	DisplayServer.virtual_keyboard_hide()
	done_button.disabled = true
	back_button.disabled = true
	back_button.get_child(0).modulate = Color(0.7, 0.7, 0.7, 0.7)
	done_button.get_child(0).modulate = Color(0.7, 0.7, 0.7, 0.7)
	
	var res := await Talo.player_auth.login(username_input.text, password_input.text)
	match res:
		Talo.player_auth.LoginResult.FAILED:
			match Talo.player_auth.last_error.get_code():
				TaloAuthError.ErrorCode.INVALID_CREDENTIALS:
					_show_login_error("Username or password is incorrect")
				_:
					print(Talo.player_auth.last_error.get_string())
					_show_login_error("Error unknown!")
		Talo.player_auth.LoginResult.VERIFICATION_REQUIRED:
			pass
		Talo.player_auth.LoginResult.OK:
			login.connect(get_tree().current_scene._on_login)
			login.emit()
			login.disconnect(get_tree().current_scene._on_login)

func _show_login_error(message):
	username_instruction.text = message
	username_instruction.modulate = Color(1, 0, 0)
	
	# Fun wiggle animation
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(username_input, "position:x", username_input.position.x + 10, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(username_input, "position:x", username_input.position.x - 10, 0.1)
	tween.tween_property(username_input, "position:x", username_input.position.x, 0.1)
	
	done_button.disabled = false
	back_button.disabled = false
	back_button.get_child(0).modulate = Color(1, 1, 1, 1)
	done_button.get_child(0).modulate = Color(1, 1, 1, 1)
	
	await get_tree().create_timer(1.5).timeout
	username_instruction.text = "Enter player's username."
	username_instruction.modulate = Color(1, 1, 1, 0.411765)

func _on_check_box_toggled(toggled_on: bool) -> void:
	password_input.secret = not toggled_on
