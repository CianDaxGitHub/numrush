extends Node2D

@onready var eyesOpt = [
	preload("res://char/expressions/eyes/eyes0.png"),
	preload("res://char/expressions/eyes/eyes1.png"),
	preload("res://char/expressions/eyes/eyes2.png"),
	preload("res://char/expressions/eyes/eyes3.png"),
	preload("res://char/expressions/eyes/eyes4.png"),
	preload("res://char/expressions/eyes/eyes5.png"),
	preload("res://char/expressions/eyes/eyes6.png")
	]

var eyesInd: int = 0

@onready var browsOpt = [
	preload("res://char/expressions/brows/brow0.png"),
	preload("res://char/expressions/brows/brow1.png"),
	preload("res://char/expressions/brows/brow2.png"),
	preload("res://char/expressions/brows/brow3.png"),
	preload("res://char/expressions/brows/brow4.png")
	]

var browsInd: int = 0

@onready var mouthOpt = [
	preload("res://char/expressions/mouth/mouth0.png"),
	preload("res://char/expressions/mouth/mouth1.png"),
	preload("res://char/expressions/mouth/mouth2.png"),
	preload("res://char/expressions/mouth/mouth3.png"),
	preload("res://char/expressions/mouth/mouth4.png"),
	preload("res://char/expressions/mouth/mouth5.png"),
	preload("res://char/expressions/mouth/mouth6.png"),
	preload("res://char/expressions/mouth/mouth7.png"),
	preload("res://char/expressions/mouth/mouth8.png"),
	preload("res://char/expressions/mouth/mouth9.png"),
	preload("res://char/expressions/mouth/mouth10.png"),
	preload("res://char/expressions/mouth/mouth11.png")
	]

var mouthInd: int = 0

@onready var brows = %brows
@onready var eyes = %eyes
@onready var mouth = %mouth
@onready var hat = %hat

var browSpeech: int = 0
var eyeSpeech: int = 0
var mouthOpen: int = 0
var mouthClose: int = 0

@export_range(0, 6) var eyeInit: int = 0
@export_range(0, 11) var mouthInit: int = 0
@export_range(0, 4) var browInit: int = 0

@onready var anim = $AnimationPlayer
@onready var tree = $AnimationTree
@onready var fit = get_tree().current_scene.get_node("levelProgress")
@onready var cloth = get_tree().current_scene.get_node("clothingStatus")

func _ready() -> void:
	_switch_expression(eyeInit, mouthInit, browInit)
	if fit.currentFit[1] == "def":
		set_default()
	else:
		var index = cloth.loader.find(fit.currentFit[1] + ".tres")
		var res = cloth.resList[index]
		
		if res.bought == true:
			clothes_change(res)
		else:
			set_default()

func talk_sprite1():
	_switch_expression(eyeSpeech, mouthOpen, browSpeech)

func talk_sprite2():
	_switch_expression(eyeSpeech, mouthClose, browSpeech)

func _switch_expression(eyesNew: int = 0, mouthNew: int = 0, browsNew: int = 0):
	eyes.texture = eyesOpt[eyesNew]
	eyesInd = eyesNew
	brows.texture = browsOpt[browsNew]
	browsInd = browsNew
	mouth.texture = mouthOpt[mouthNew]
	mouthInd = mouthNew

func set_default():
	hat.visible = false
	hat.texture = null

func clothes_change(res: ClothingInfo):
	hat.visible = true
	hat.texture = res.atlasTex
