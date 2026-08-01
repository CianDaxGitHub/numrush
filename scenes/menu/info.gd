extends Control

@onready var main = $"../"

@onready var title = %titlePanel
@onready var target = %targetLabel
@onready var time = %timeLabel

@onready var themeList = [
	[preload("res://themes/addSmall.tres"), preload("res://themes/addText.tres"), preload("res://themes/addText2.tres")],
	[preload("res://themes/subSmall.tres"), preload("res://themes/subText.tres"), preload("res://themes/subText2.tres")],
	[preload("res://themes/mulSmall.tres"), preload("res://themes/mulText.tres"), preload("res://themes/mulText2.tres")],
	[preload("res://themes/divSmall.tres"), preload("res://themes/divText.tres"), preload("res://themes/divText2.tres")],
	[preload("res://themes/mixSmall.tres"), preload("res://themes/mixText.tres"), preload("res://themes/mixText2.tres")]
]

signal gameTransfer

func _ready() -> void:
	var opType = main.gameSetup[0]
	var lvl = main.gameSetup[1]
	var timeVal = main.gameSetup[2]
	var targetVal = main.gameSetup[5]
	
	var opString: String
	
	match opType:
		0:
			opString = "Addition"
		1:
			opString = "Subtraction"
		2:
			opString = "Multiplication"
		3:
			opString = "Division"
		4:
			opString = "Mixed"
	
	title.add_theme_stylebox_override("panel", themeList[opType][0])
	title.get_child(0).label_settings = themeList[opType][2]
	title.get_child(0).text = "%s\nChallenge #%d" % [opString, lvl]
	
	target.text = "Solve 23 items correctly within %d seconds!" % targetVal
	
	if int(fmod(timeVal, 60)) == 0:
		time.text = "%d minutes" % [int(fmod(timeVal, 3600) / 60)]
	else:
		time.text = "%d min and %d seconds" % [int(fmod(timeVal, 3600) / 60), int(fmod(timeVal, 60))]


func _on_play_button_pressed() -> void:
	$Panel.visible = true
	$PolyAudio.play_sfx_from_lib("mainChoice", 1, 0, 0.05)
	await get_tree().create_timer(0.6).timeout
	gameTransfer.emit()
