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

@onready var handLOpt = [
	preload("res://char/expressions/hands/handL1.png"),
	preload("res://char/expressions/hands/handL2.png"),
	preload("res://char/expressions/hands/handL3.png")
	]
@onready var handROpt = [
	preload("res://char/expressions/hands/handR1.png"),
	preload("res://char/expressions/hands/handR2.png"),
	preload("res://char/expressions/hands/handR3.png")
	]

var handLInd: int = 0
var handRInd: int = 0

@onready var handL = %handL
@onready var handR = %handR

@onready var top = [%foreArmRTop, %upperArmRTop, %shoulderRTop, %torsoTop, %foreArmLTop, %upperArmLTop, %shoulderLTop]
@onready var bottom = [%calfRBottom, %thighRBottom, %calfLBottom, %thighLBottom, %hipBottom]
@onready var knees = [%kneeR, %kneeL]
@onready var shoes = [%shoeR, %shoeL]

@onready var blink: Timer = $blink

@onready var anim = $AnimationPlayer

@onready var fit = get_tree().current_scene.get_node("levelProgress")
@onready var cloth = get_tree().current_scene.get_node("clothingStatus")

func _ready() -> void:
	blink.timeout.connect(_on_blink)
	for i in range(fit.currentFit.size()):
		if fit.currentFit[i] == "def":
			match i:
				0:
					set_default(0)
				1:
					set_default(3)
				2:
					set_default(4)
				3:
					set_default(7)
		else:
			var index = cloth.loader.find(fit.currentFit[i] + ".tres")
			var res = cloth.resList[index]
			
			if res.bought == true:
				clothes_change(res)
			else:
				set_default(res.category)

func _on_blink():
	var chance: int = randi_range(0, 4)
	blink.wait_time = randi_range(2, 4)
	blink.start()
	
	match chance:
		4:
			_switch_eyes(2)
			await get_tree().create_timer(0.1).timeout
			_switch_eyes(0)
			await get_tree().create_timer(0.3).timeout
			_switch_eyes(2)
			await get_tree().create_timer(0.1).timeout
			_switch_eyes(0)
		_:
			_switch_eyes(2)
			await get_tree().create_timer(0.1).timeout
			_switch_eyes(0)

func start_blinking():
	blink.wait_time = randi_range(2,4)
	blink.start()

func stop_blinking():
	blink.stop()

func _switch_eyes(eyesNew: int = 0):
	eyes.texture = eyesOpt[eyesNew]
	eyesInd = eyesNew

func _switch_expression(eyesNew: int = 0, mouthNew: int = 0, browsNew: int = 0, handLNew: int = 0, handRNew: int = 0):
	eyes.texture = eyesOpt[eyesNew]
	eyesInd = eyesNew
	brows.texture = browsOpt[browsNew]
	browsInd = browsNew
	mouth.texture = mouthOpt[mouthNew]
	mouthInd = mouthNew
	handL.texture = handLOpt[handLNew]
	handLInd = handLNew
	handR.texture = handROpt[handRNew]
	handRInd = handRNew

func set_default(category: int):
	match category:
		0, 1, 2:
			for i in range(top.size()):
				top[i].visible = false
				top[i].texture = null
		3:
			hat.visible = false
			hat.texture = null
		4, 5, 6:
			for i in range(knees.size()):
				knees[i].visible = true
			for j in range(bottom.size()):
				bottom[j].visible = false
				bottom[j].texture = null
		7:
			for i in range(shoes.size()):
				shoes[i].visible = false
				shoes[i].texture = null

func clothes_change(res: ClothingInfo):
	match res.category:
		0, 1, 2:
			for i in range(top.size()):
				top[i].visible = true
				top[i].texture = res.atlasTex
		3:
			hat.visible = true
			hat.texture = res.atlasTex
		4, 5:
			for i in range(knees.size()):
				knees[i].visible = true
			for j in range(bottom.size()):
				bottom[j].visible = true
				bottom[j].texture = res.atlasTex
		6:
			for i in range(knees.size()):
				knees[i].visible = false
			for j in range(bottom.size()):
				bottom[j].visible = true
				bottom[j].texture = res.atlasTex
		7:
			for i in range(shoes.size()):
				shoes[i].visible = true
				shoes[i].texture = res.atlasTex
