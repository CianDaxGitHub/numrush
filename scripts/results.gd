extends Control

var type
var initTime
var finalTime
var estTime
var correctAns 
var target
var level
var coins
var success: int = 0

var gameResults = []
var questions = []

var _path = "user://history.save"
var off
@onready var main = $"../"
@onready var anim = $AnimationPlayer
@onready var score = %score
@onready var time = %time
@onready var remarks = %remarks
@onready var next = %next


@onready var character = %Char

@onready var remarksTheme = [preload("res://themes/successText.tres"), preload("res://themes/failureText.tres")]

var resultsBG = ["res://images/bg/bg_results1.png", "res://images/bg/bg_results2.png", "res://images/bg/bg_results3.png", "res://images/bg/bg_results4.png", "res://images/bg/bg_results5.png"]

var remarkBGM = ["res://sounds/bgm/remark_fail.mp3", "res://sounds/bgm/remark_success.mp3"]
var resultsBGM = ["res://sounds/bgm/res_failloop.mp3", "res://sounds/bgm/res_successloop.mp3"]

signal lvlSuccess(op)
signal next_level
signal retry
signal lvlSelect
signal home
signal boardSend(boardName, boardScore, boardTotal, boardTime, boardLevel)

func _ready() -> void:
	%background.texture = load(resultsBG[randi_range(0, 4)])
	character.anim.play("result_start")
	type = main._gameInfo[0]
	initTime = main._gameInfo[1]
	finalTime = main._gameInfo[2]
	estTime = initTime - finalTime
	correctAns = main._gameInfo[3]
	level = main._gameInfo[4]
	target = main._gameInfo[5]
	questions = main._questionList
	
	if correctAns >= 23:
		score.label_settings = load("res://themes/successText2.tres")
	else:
		score.label_settings = load("res://themes/failureText2.tres")
	
	if estTime <= target:
		time.label_settings = load("res://themes/successText2.tres")
	else:
		time.label_settings = load("res://themes/failureText2.tres")
	
	if main.offline == true:
		%goalText.text = "Connect to the internet to get to the leaderboards!"
	else:
		%goalText.text = "Your score was added to the leaderboards!"
	
	_calculate_results()
	anim.play("res_intro")
	await anim.animation_finished
	anim.play("res_display")
	await anim.animation_finished
	await get_tree().create_timer(0.8).timeout
	anim.play("res_finished")

func _calculate_results():
	score.text = "%d/30" % correctAns
	time.text = "%02d:%02d.%02d" % [int(fmod(estTime, 3600) / 60), int(fmod(estTime, 60)), int(fmod(estTime, 1) * 100)]
	if level > 9:
		next.visible = false
	if correctAns >= 23 && estTime <= target:
		success = 1
		remarks.text = "SUCCESS!"
		remarks.label_settings = remarksTheme[0]
	else:
		success = 0
		remarks.text = "FAILURE..."
		remarks.label_settings = remarksTheme[1]
		next.visible = false
	
	$remarks.stream = load(remarkBGM[success])
	$bgm.stream = load(resultsBGM[success])
	
	coins = final_coin_algo()
	gameResults = [type, estTime, correctAns, level, coins, success, target]
	main.get_node("levelProgress").coins += coins
	_append_to_history()
	main.game_save()
	
	var boardsBasis = correctAns / estTime
	if success > 0:
		boardSend.connect(main.send_to_boards)
		boardSend.emit("%s" % [(["add", "sub", "mul", "div", "mix"][type])], boardsBasis, score.text, estTime, level)
		boardSend.disconnect(main.send_to_boards)

func final_coin_algo() -> int:
	# uses the initial time, the remaining time when you finish, the amount of questions, and the amount of correct answers you made.
	# a small amount of coins can also be offered if time runs out, correct answers give you extra.
	var a = pow(finalTime, 2)
	var b = 50 - (20 - (level * 2))
	var c = correctAns / 30
	var d = level / 5
	var e = initTime / 30
	
	var f = 3 + (level / 2) + (correctAns / 5)
	var g = (500 / initTime)
	
	return floor(((((a / b) * c * d) * 0.2) / e) + f + g)

func _particle_system():
	$remarks.play()
	%coinLabel.text = "+%d" % final_coin_algo()
	if success == 1:
		character.anim.play("result_success")
		$successParticles.emitting = true
		$resultAudio.play_sfx_from_lib("success", 1, 0)
		lvlSuccess.connect(get_tree().current_scene._on_level_success)
		lvlSuccess.emit(type)
		lvlSuccess.disconnect(get_tree().current_scene._on_level_success)
		await anim.animation_finished
		await get_tree().create_timer(1).timeout
		anim.play("leaderboards")
	else:
		character.anim.play("result_fail")
		$failureParticles.emitting = true
		$resultAudio.play_sfx_from_lib("failure", 1, 0)
	await get_tree().create_timer(2).timeout
	$bgm.play()

func _on_btn_next_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($bgm, "volume_db", -80.0, 0.8)
	next_level.connect(get_tree().current_scene._on_next_level)
	next_level.emit(type)
	next_level.disconnect(get_tree().current_scene._on_next_level)

func _on_btn_retry_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($bgm, "volume_db", -80.0, 0.8)
	retry.connect(get_tree().current_scene._on_retry)
	retry.emit()
	retry.disconnect(get_tree().current_scene._on_retry)

func _on_btn_levels_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($bgm, "volume_db", -80.0, 0.8)
	lvlSelect.connect(get_tree().current_scene._on_levels)
	lvlSelect.emit()
	lvlSelect.disconnect(get_tree().current_scene._on_levels)

func _on_btn_home_pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($bgm, "volume_db", -80.0, 0.8)
	main._gameSetup = null
	main._gameInfo = null
	home.connect(get_tree().current_scene._on_home)
	home.emit()
	home.disconnect(get_tree().current_scene._on_home)

func _append_to_history():
	var file
	var resultList = []
	var qtnList = []
	
	if FileAccess.file_exists(_path):
		file = FileAccess.open(_path, FileAccess.READ)
		resultList = file.get_var()
		qtnList = file.get_var()
		file.close()
	
	file = FileAccess.open(_path, FileAccess.WRITE)
	resultList.append(gameResults)
	qtnList.append(questions)
	file.store_var(resultList)
	file.store_var(qtnList)
	file.close()
