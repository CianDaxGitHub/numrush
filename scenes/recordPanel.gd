extends Control

var type = 0
var estTime = 24.94
var correct = 15
var lvl = 1
var coins = 20
var target = 105
var success = 1

var questions

@onready var header = %headerLabel
@onready var coinLabel = %coinLabel
@onready var scoreLabel = %scoreLabel
@onready var timeLabel = %timeLabel
@onready var remarks = %remarkLabel

@onready var ddBase = preload("res://scenes/ddHistory.tscn")

func _ready() -> void:
	header.text = "%s Challenge #%d" % [["Addition", "Subtraction", "Multiplication", "Division", "Mixed"][type], lvl]
	
	coinLabel.text = "+%d" % coins
	scoreLabel.text = "%d/30" % correct
	if correct >= 23:
		scoreLabel.label_settings = load("res://themes/recordSuccess.tres")
	else:
		scoreLabel.label_settings = load("res://themes/recordFailure.tres")
	
	timeLabel.text = "%02d:%02d.%02d" % [int(fmod(estTime, 3600) / 60), int(fmod(estTime, 60)), int(fmod(estTime, 1) * 100)]
	if estTime <= target:
		timeLabel.label_settings = load("res://themes/recordSuccess.tres")
	else:
		timeLabel.label_settings = load("res://themes/recordFailure.tres")
	
	remarks.text = "%s" % ["FAILURE", "SUCCESS"][success]
	if success == 1:
		remarks.label_settings = load("res://themes/recordSuccess.tres")
	else:
		remarks.label_settings = load("res://themes/recordFailure.tres")

func _on_record_btn_pressed() -> void:
	var ddNew = ddBase.instantiate()
	ddNew.type = type
	ddNew.lvl = lvl
	ddNew.questions = questions
	get_tree().root.add_child(ddNew)
