extends Control

@onready var name_input = %Name
@onready var age_input = %Age
@onready var male_checkbox = %btnMale
@onready var female_checkbox = %btnFemale
@onready var username_input = %Username
@onready var username_warning = %userWarning
@onready var password_input = %Password
@onready var password_warning = %passWarning
@onready var done_button = %Done
@onready var back_button = %btnBack

@export var genderOption: ButtonGroup
var gender: String

signal props(nme, a, gnd)

var tween: Tween

func _ready():
	name_input.text_changed.connect(_on_text_changed)
	age_input.text_changed.connect(_on_text_changed)
	username_input.text_changed.connect(_on_text_changed)
	password_input.text_changed.connect(_on_text_changed)
	
	# Glow on focus
	name_input.focus_entered.connect(_input_glow.bind(name_input))
	age_input.focus_entered.connect(_input_glow.bind(age_input))
	username_input.focus_entered.connect(_input_glow.bind(username_input))
	password_input.focus_entered.connect(_input_glow.bind(password_input))
	
	username_warning.modulate = Color(1, 0, 0)
	password_warning.modulate = Color(1, 0, 0)

	# Disabled start
	done_button.disabled = true
	done_button.modulate = Color(0.7, 0.7, 0.7)
	
	_validate_form()

# --- ✨ Playful Animations ---

func _animate_warning(label: Label, message: String, color: Color):
	label.text = message
	label.modulate = color
	
	done_button.disabled = false
	back_button.disabled = false
	back_button.get_child(0).modulate = Color(1, 1, 1, 1)
	done_button.get_child(0).modulate = Color(1, 1, 1, 1)
	
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(username_input, "position:x", username_input.position.x + 10, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(username_input, "position:x", username_input.position.x - 10, 0.1)
	tween.tween_property(username_input, "position:x", username_input.position.x, 0.1)

func _input_glow(node: Control):
	if tween: tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "modulate", Color(0.8, 0.8, 1), 0.2)
	tween.tween_property(node, "modulate", Color(1, 1, 1), 0.4)

# --- Validation handlers ---

func _on_text_changed(_new_text):
	_validate_form()

func _on_pressed():
	$PolyAudio.play_sfx_from_lib("click", 1.0, -14)
	_validate_form()
	_determine_gender()

func _determine_gender():
	var btnPress = genderOption.get_pressed_button()
	
	match btnPress.name:
		"btnMale":
			gender = "Male"
		"btnFemale":
			gender = "Female"

# --- Form validation ---
func _validate_form():
	var is_valid: bool = false

	if name_input.text.strip_edges().is_empty():
		pass
	elif not male_checkbox.button_pressed and not female_checkbox.button_pressed:
		pass
	elif age_input.text.strip_edges().is_empty() or age_input.text.to_int() <= 0:
		pass
	elif username_input.text.strip_edges().is_empty():
		pass
	elif password_input.text.is_empty():
		pass
	else:
		is_valid = true

	done_button.disabled = not is_valid

	if is_valid:
		done_button.modulate = Color(1, 1, 1)
	else:
		done_button.modulate = Color(0.7, 0.7, 0.7)

# --- Button actions ---
func _on_done_pressed():
	DisplayServer.virtual_keyboard_hide()
	done_button.disabled = true
	back_button.disabled = true
	back_button.get_child(0).modulate = Color(0.7, 0.7, 0.7, 0.7)
	done_button.get_child(0).modulate = Color(0.7, 0.7, 0.7, 0.7)
	
	var error: bool
	if password_input.text.length() < 8:
		_animate_warning(password_warning, "Password should be at least 8 characters!", Color(1, 0, 0))
		error = true
	
	if error:
		return
	else:
		var res := await Talo.player_auth.register(username_input.text, password_input.text)
		if res != OK:
			match Talo.player_auth.last_error.get_code():
				TaloAuthError.ErrorCode.IDENTIFIER_TAKEN:
					_animate_warning(username_warning, "Username is already taken!", Color(1, 0, 0))
				_:
					_animate_warning(username_warning, "Error unknown!", Color(1, 0, 0))
		else:
			props.connect(get_tree().current_scene._on_signup)
			props.emit(name_input.text, age_input.text, gender)
			props.disconnect(get_tree().current_scene._on_signup)

func _on_check_box_toggled(toggled_on: bool) -> void:
	password_input.secret = not toggled_on
