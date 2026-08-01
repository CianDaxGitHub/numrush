extends Control

var firstNo: float
var secondNo: float
var operation: int
var answer: String
var checked: bool
var cardFace: int
var idx: int

@onready var firstOp = %firstOp
@onready var secondOp = %secondOp
@onready var ansLabel = %ansLabel
@onready var ansText = %ansText
@onready var opAdd = %opAdd
@onready var opSub = %opSub
@onready var opMul = %opMul
@onready var opDiv = %opDiv
@onready var txtIndex = %txtIndex

@onready var prev = %prevButton
@onready var next = %nextButton
@onready var close = %closeButton
@onready var anim = $AnimationPlayer

func _change_info():
	firstOp.text = "%d" % int(firstNo)
	secondOp.text = "%d" % int(secondNo)
	ansText.text = "%s" % answer
	txtIndex.text = "(No. %d)" % idx
	
	opAdd.visible = false
	opSub.visible = false
	opMul.visible = false
	opDiv.visible = false
	
	match operation:
		0:
			opAdd.visible = true
		1:
			opSub.visible = true
		2:
			opMul.visible = true
		3:
			opDiv.visible = true
	if checked == true:
		ansLabel.modulate = Color(0.943, 0.554, 0.299, 1)
	else:
		ansLabel.modulate = Color(0, 0, 0, 1)
