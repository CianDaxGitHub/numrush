extends Control

@onready var carousel = %MenuCarousel
@onready var opLabel = $%opLabel
var label_idx: int = 0

@onready var character = $Char

func _ready() -> void:
	character.anim.play("menu_start")
	for child in find_children("*", "MenuButtonState", true):
		child.pressed.connect(_menu_button_pressed.bind(child))

func _menu_button_pressed(button):
	$Panel.visible = true
	var toState = button.toState
	
	match toState:
		"levels":
			character.anim.play("to_diff")
		"shop":
			character.anim.play("to_shop")
		"about":
			character.anim.play("to_about")

func _on_left_pressed() -> void:
	carousel.left()
	label_idx = clampi(label_idx - 1, 0, 4)
	opLabel.text = "%s" % _return_op_label(label_idx)

func _on_right_pressed() -> void:
	carousel.right()
	label_idx = clampi(label_idx + 1, 0, 4)
	opLabel.text = "%s" % _return_op_label(label_idx)

func _return_op_label(idx: int) -> String:
	return["Addition", "Subtraction", "Multiplication", "Division", "Mixed"][idx]

func _on_btn_settings_pressed() -> void:
	var settings = load("res://scenes/settings.tscn").instantiate()
	add_child(settings)
