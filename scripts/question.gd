extends Control

var listNo: int

var firstNo: float
var secondNo: float
var operation: int
var answer: String
var checked: bool

@onready var firstOp = %firstOp
@onready var secondOp = %secondOp
@onready var ansLabel = %ansLabel
@onready var ansText = %ansText

@onready var opAdd = %opAdd
@onready var opSub = %opSub
@onready var opMul = %opMul
@onready var opDiv = %opDiv

signal questionClicked(no, pivot)

func _ready() -> void:
	firstOp.text = "%d" % int(firstNo)
	secondOp.text = "%d" %  int(secondNo)
	ansText.text = "%s" % answer
	
	match operation:
		0:
			opAdd.visible = true
		1:
			opSub.visible = true
		2:
			opMul.visible = true
		3:
			opDiv.visible = true

func _process(_delta: float) -> void:
	ansText.text = answer
	if checked == true:
		ansLabel.modulate = Color(0.943, 0.554, 0.299, 1)
	else:
		ansLabel.modulate = Color(0, 0, 0, 1)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			questionClicked.emit(listNo, pivot_offset)
