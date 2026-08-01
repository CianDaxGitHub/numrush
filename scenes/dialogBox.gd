extends Control

@export var label: Label
@export var timer: Timer
@export var audioPlayer: AudioStreamPlayer
@onready var animPlayer = $AnimPlayer

var text = ""
var letterIndex: int = 0

var letterTime: float = 0.04
var spaceTime: float = 0.07
var puncTime: float = 0.15

var punc: bool = true

signal startSpeech
signal punctuation
signal finished_displaying()

func display_text(boxDisplay: String):
	text = boxDisplay
	letterIndex = 0
	label.text = ""
	_display_letter()

func _display_letter():
	if !text[letterIndex] == "+":
		label.text += text[letterIndex]
	_play_dialog_sounds()
	letterIndex += 1
	
	if letterIndex >= text.length():
		finished_displaying.emit()
		return
		
	
	match text[letterIndex - 1]:
		".", ",", "?", "!", "+":
			timer.start(puncTime)
			if punc == false:
				punctuation.emit()
				punc = true
		" ":
			timer.start(spaceTime)
		_:
			timer.start(letterTime)
			if punc == true:
				startSpeech.emit()
				punc = false

func _on_display_timer_timeout() -> void:
	_display_letter()

func _play_dialog_sounds():
	match text[letterIndex]:
		".", ",", " ", "?", "!", "+":
			pass
		_:
			match text[letterIndex + 1]:
				".":
					audioPlayer.play_sfx_from_lib("blip", 1 - randf_range(0.1, 0.15), -20)
				",":
					audioPlayer.play_sfx_from_lib("blip", 1 - randf_range(0.03, 0.06), -20)
				"?":
					audioPlayer.play_sfx_from_lib("blip", 1.3, -20)
				"!":
					audioPlayer.play_sfx_from_lib("blip", 1.4, -20)
				_: 
					if text[letterIndex] in ["a", "e", "i", "o", "u"]:
						audioPlayer.play_sfx_from_lib("blip", 1 + randf_range(0.05, 0.10), -20)
					else:
						audioPlayer.play_sfx_from_lib("blip", 1 + randf_range(-0.05, 0.05), -20)
