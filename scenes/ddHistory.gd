extends Control

var type
var lvl
@onready var title = %titleLabel
@onready var cont = %questionContainer

var questions
@onready var questionBase = preload("res://scenes/questionHistory.tscn")

func _ready() -> void:
	title.text = "%s CHALLENGE #%d" % [["ADDITION", "SUBTRACTION", "MULTIPLICATION", "DIVISION", "MIXED"][type], lvl]
	
	for i in range(questions.size()):
		var newQuestion = questionBase.instantiate()
		newQuestion.firstNo = questions[i][0]
		newQuestion.secondNo = questions[i][1]
		newQuestion.operation = questions[i][2]
		newQuestion.answer = questions[i][3]
		cont.add_child(newQuestion)

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("exit_scene")

func _on_btn_close_pressed() -> void:
	if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("exit_scene")
