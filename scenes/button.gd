extends HFlowContainer

@export var keyboard: Node3D

signal updateAnswer(case)

func _ready() -> void:
	for child in self.get_children():
		child.pressed.connect(_button_pressed.bind(child))

func _button_pressed(button):
	var btnCase: int = int(button.text)
	var btnInst: String = "btn" + str(btnCase + 1)
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
	
	updateAnswer.emit(btnCase)
	
	keyboard.get_node(btnInst).position.y = 0.967
	var localPos: Vector3 = keyboard.get_node(btnInst).position
	
	tween.tween_property(keyboard.get_node(btnInst), "position", localPos + Vector3(0, -0.12, 0), 0.05)
	tween.tween_property(keyboard.get_node(btnInst), "position", localPos + Vector3(0, 0.14, 0), 0.05)
	tween.tween_property(keyboard.get_node(btnInst), "position", localPos + Vector3(0, -0.02, 0), 0.08)
