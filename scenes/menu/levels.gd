extends Control

@onready var main = $"../"
@onready var progress = $"../../levelProgress"

var gameSetup = []
var opType = 0
var lvl: int

@onready var cont = %lvlGroup

@onready var themeList = [
	[preload("res://themes/addSmall.tres"), preload("res://themes/addText.tres"), preload("res://themes/addText2.tres")],
	[preload("res://themes/subSmall.tres"), preload("res://themes/subText.tres"), preload("res://themes/subText2.tres")],
	[preload("res://themes/mulSmall.tres"), preload("res://themes/mulText.tres"), preload("res://themes/mulText2.tres")],
	[preload("res://themes/divSmall.tres"), preload("res://themes/divText.tres"), preload("res://themes/divText2.tres")],
	[preload("res://themes/mixSmall.tres"), preload("res://themes/mixText.tres"), preload("res://themes/mixText2.tres")]
]

var unlock_value: int

signal level_select(level, time, fNo, sNo, target)

func _ready() -> void:
	gameSetup = main.gameSetup
	opType = gameSetup[0]
	unlock_value = progress.level_progress[opType]
	for j in cont.get_children():
		j.get_child(0).add_theme_stylebox_override("normal", themeList[opType][0])
		j.get_child(0).add_theme_stylebox_override("hover", themeList[opType][0])
		j.get_child(0).add_theme_stylebox_override("pressed", themeList[opType][0])
		j.get_child(0).get_child(0).label_settings = themeList[opType][1]
		
	var i: int = 0
	for child in find_children("*", "LevelButton", true):
		if i < unlock_value + 1:
			child.disabled = false
			i += 1
		child.pressed.connect(_button_pressed.bind(child))

func _button_pressed(button):
	lvl = int(button.get_child(0).text)
	var res = button.levelList[opType]
	level_select.emit(lvl, res.time, res.firstMax, res.secondMax, res.target, res.probability)
