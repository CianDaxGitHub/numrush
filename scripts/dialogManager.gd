extends Node

@onready var dialogScene = preload("res://scenes/dialogBox.tscn")


var dialogLines: Array[String] = []
var lineIndex: int = 0

var dialogBox
var dialogPosition: Vector2

var isActive: bool = false
var canAdvance: bool = false

var stop = false

signal dialogRefresh
signal startAnim
signal stopAnim
signal finished

func start_dialog(position: Vector2, lines: Array[String]):
	if isActive:
		return
	
	dialogLines = lines
	dialogPosition = position
	
	_show_dialog_box()
	isActive = true

func _show_dialog_box():
	dialogBox = dialogScene.instantiate()
	dialogBox.startSpeech.connect(_on_start_speech)
	dialogBox.punctuation.connect(_on_punctuation)
	dialogBox.finished_displaying.connect(_on_dialog_finished_displaying)
	self.add_child(dialogBox)
	dialogBox.animPlayer.play("open_dialog")
	dialogBox.global_position = dialogPosition
	await dialogBox.animPlayer.animation_finished
	dialogBox.display_text(dialogLines[lineIndex])
	canAdvance = false

func _on_start_speech():
	startAnim.emit()

func _on_punctuation():
	stopAnim.emit()

func _refresh_dialog_box():
	dialogRefresh.emit()
	startAnim.emit()
	dialogBox.text = ""
	lineIndex += 1
	dialogBox.display_text(dialogLines[lineIndex])

func _on_dialog_finished_displaying():
	stopAnim.emit()
	await get_tree().create_timer(1).timeout
	if lineIndex >= dialogLines.size() - 1:
		await get_tree().create_timer(0.5).timeout
		dialogBox.animPlayer.play("close_dialog")
		dialogBox.startSpeech.disconnect(_on_start_speech)
		dialogBox.punctuation.disconnect(_on_punctuation)
		await dialogBox.animPlayer.animation_finished
		dialogBox.text = ""
		dialogBox.queue_free()
		finished.emit()
		lineIndex = 0
		isActive = false
		return
	else:
		_refresh_dialog_box()
