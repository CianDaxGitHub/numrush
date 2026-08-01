extends Control

var firstNo: float
var secondNo: float
var operation: int
var answer: int

@onready var firstOp = %firstOp
@onready var secondOp = %secondOp
@onready var ansLabel = %ansLabel
@onready var ansText = %ansText

@onready var opAdd = %opAdd
@onready var opSub = %opSub
@onready var opMul = %opMul
@onready var opDiv = %opDiv

func _ready() -> void:
	var result
	firstOp.text = "%d" % firstNo
	secondOp.text = "%d" %  secondNo
	ansText.text = "%d" % answer
	
	match operation:
		0:
			opAdd.visible = true
			result = int(firstNo + secondNo)
		1:
			opSub.visible = true
			result = int(firstNo - secondNo)
		2:
			opMul.visible = true
			result = int(firstNo * secondNo)
		3:
			opDiv.visible = true
			result = int(firstNo / secondNo)
	
	if answer == result:
		ansLabel.modulate = Color.GREEN
	elif answer < 0:
		ansLabel.modulate = Color.DARK_ORANGE
		ansText.text = "%d" % result
	else:
		ansLabel.modulate = Color.RED
