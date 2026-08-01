extends Control

@export var dd: Control

@onready var offset = get_viewport_rect().size.x / 2

var fMax = 80
var sMax = 50
var opType: int = 2
var correctAns: int
var target: float
var lvl: int = 1
var checked: bool

var prob: PackedFloat32Array = [0.4, 1, 0]

signal gameInit
signal gameplayComplete(info, questions)
signal updateCard

signal hintDialog

signal retry
signal quit

var initTime: float = 70
var finalTime: float
@onready var currentItem: int
# dd var is used to get the flowcontainer node to properly add children nodes inside
@onready var parent = dd.get_node("MarginContainer/VBoxContainer/FlowContainer")
var ticked: int = 0
@onready var card = %Card
@onready var countdown = %Countdown

var gameBG = ["res://images/bg/bg_game1.png", "res://images/bg/bg_game2.png", "res://images/bg/bg_game3.png", "res://images/bg/bg_game4.png", "res://images/bg/bg_game5.png"]

@onready var bgm = $gameplayBGM
@onready var bgmPlayback: AudioStreamPlaybackInteractive = $gameplayBGM.get_stream_playback()
var streams = [
	["res://sounds/bgm/add_loop.mp3", "res://sounds/bgm/add_hurryloop.mp3"],
	["res://sounds/bgm/sub_loop.mp3", "res://sounds/bgm/sub_hurry.mp3"],
	["res://sounds/bgm/mul_loop.mp3", "res://sounds/bgm/mul_hurryloop.mp3"],
	["res://sounds/bgm/div_loop.mp3", "res://sounds/bgm/div_hurryloop.mp3"],
	["res://sounds/bgm/mixed_loop.mp3", "res://sounds/bgm/mixed_hurryloop.mp3"]
]

var gameInfo = [0, 0, 0, 0, 0, 0] # type, initTime, finalTime, correct, lvl, target
var questionList = [] # all questions
var questionInfo = [] # generated question

@onready var questionBase = preload("res://scenes/question.tscn")

func _acquire_level_data(setup: Array) -> void: # once the gameManager's signal is emitted, it embeds the setup information into the game
	opType = setup[0]
	lvl = setup[1]
	initTime = setup[2]
	%Countdown.initTime = setup[2]
	fMax = str_to_var(setup[3])
	sMax = str_to_var(setup[4])
	target = setup[5]
	prob = str_to_var(setup[6])

func has_decimal(f: float) -> bool: # checks for decimal results to prevent non-integer questions from showing up.
	return abs(f - int(f)) > 0

func weighted_digit_rng(maxNo: int, prb: PackedFloat32Array) -> float:
	var rng = RandomNumberGenerator.new()
	var maxQ: Array = [9, 99, 999]
	
	return wrapi(randi() % maxNo + 1, 1, maxQ[rng.rand_weighted(prb)])

func randomize_question(): # does what it says on the title
	var firstNumber: float
	var secondNumber: float
	var op: int # 0 - Addition, 1 - Subtraction, 2 - Multiplication, 3 - Division
	var finalResult: float # firstNumber, secondNumber and finalResult are floats to verify integers for division questions
	match opType:
		4:
			op = randi() % 4
			firstNumber = weighted_digit_rng(fMax[op], prob)
			secondNumber = weighted_digit_rng(sMax[op], prob)
		_:
			op = opType
			firstNumber = weighted_digit_rng(fMax, prob)
			secondNumber = weighted_digit_rng(sMax, prob)
	
	match op:
		0:
			if opType == 4:
				firstNumber = weighted_digit_rng(fMax[0], prob)
				secondNumber = weighted_digit_rng(sMax[0], prob)
			else:
				firstNumber = weighted_digit_rng(fMax, prob)
				secondNumber = weighted_digit_rng(sMax, prob)
		1:
			# apparently, do while loops don't exist. which is why the code is executed twice this way.
			if opType == 4:
				firstNumber = weighted_digit_rng(fMax[1], prob)
				secondNumber = weighted_digit_rng(sMax[1], prob)
			else:
				firstNumber = weighted_digit_rng(fMax, prob)
				secondNumber = weighted_digit_rng(sMax, prob)
			finalResult = firstNumber - secondNumber
			while finalResult < 0:
				# the finalResult checks for any negative results.
				# if the result is negative the while loop would repeat.
				if opType == 4:
					firstNumber = weighted_digit_rng(fMax[1], prob)
					secondNumber = weighted_digit_rng(sMax[1], prob)
				else:
					firstNumber = weighted_digit_rng(fMax, prob)
					secondNumber = weighted_digit_rng(sMax, prob)
				finalResult = firstNumber - secondNumber
		2:
			if opType == 4:
				firstNumber = weighted_digit_rng(fMax[2], prob)
				secondNumber = weighted_digit_rng(sMax[2], prob)
			else:
				firstNumber = weighted_digit_rng(fMax, prob)
				secondNumber = weighted_digit_rng(sMax, prob)
			finalResult = firstNumber * secondNumber
			while finalResult > 100:
				if opType == 4:
					firstNumber = weighted_digit_rng(fMax[2], prob)
					secondNumber = weighted_digit_rng(sMax[2], prob)
				else:
					firstNumber = weighted_digit_rng(fMax, prob)
					secondNumber = weighted_digit_rng(sMax, prob)
				finalResult = firstNumber * secondNumber
		3:
			# this process is similar to generating subtraction questions, except it checks for decimals instead.
			if opType == 4:
				firstNumber = weighted_digit_rng(fMax[3], prob)
				secondNumber = weighted_digit_rng(sMax[3], prob)
			else:
				firstNumber = weighted_digit_rng(fMax, prob)
				secondNumber = weighted_digit_rng(sMax, prob)
			finalResult = firstNumber / secondNumber
			while has_decimal(finalResult):
				if opType == 4:
					firstNumber = weighted_digit_rng(fMax[3], prob)
					secondNumber = weighted_digit_rng(sMax[3], prob)
				else:
					firstNumber = weighted_digit_rng(fMax, prob)
					secondNumber = weighted_digit_rng(sMax, prob)
				finalResult = firstNumber / secondNumber
	
	# assigns the final values to the questionInfo array
	questionInfo.append(int(firstNumber)) # 0 represents the first number of the question
	questionInfo.append(int(secondNumber)) # 1 represents the second number of the question
	questionInfo.append(op) # 2 represents the question's operation
	questionInfo.append("") # 3 represents the user's answer that updates every submission
	questionInfo.append(checked) # 4 represents whether or not the question has been checked

func _ready() -> void:
	%background.texture = load(gameBG[randi_range(0, 4)])
	%goalText.text = "Solve 23 items correctly within %d seconds!" % target
	bgm.stream.set_clip_stream(0, load(streams[opType][0]))
	bgm.stream.set_clip_stream(1, load(streams[opType][1]))
	$AnimationPlayer.play("game_intro")
	%charHead.tree.active = true

func _start_game():
	bgm.play()
	
	countdown.timeOut2.connect(_on_warning)
	gameInit.emit()
	init_questions()

func init_questions():
	for i in range(30): # repeats for a specified amount of questions
		var newQuestion = questionBase.instantiate()
		
		questionInfo = []
		randomize_question()
		
		# assigns a single randomized question into a larger list
		questionList.append(questionInfo)
		
		newQuestion.firstNo = "%s" % questionInfo[0]
		newQuestion.secondNo = "%s" %  questionInfo[1]
		newQuestion.operation = "%s" %  questionInfo[2]
		newQuestion.answer = ""
		parent.add_child(newQuestion)
		
		newQuestion.listNo = i
		newQuestion.questionClicked.connect(_on_question_clicked)
	
	$HFlowContainer.updateAnswer.connect(_on_answer_update)
	countdown.timeOut.connect(_on_time_out)

func assign_card(val): # recalibrates the card's values to reflect the selected question.
	card.firstNo = "%s" % questionList[val][0]
	card.secondNo = "%s" %  questionList[val][1]
	card.operation = "%s" %  questionList[val][2]
	card.answer = "%s" %  questionList[val][3]
	card.checked = questionList[val][4]
	card.idx = val + 1
	updateCard.connect(card._change_info)
	updateCard.emit()
	updateCard.disconnect(card._change_info)

func _on_question_clicked(listNo, pivot): # happens if you click a question
	$gameplayAudio.play_sfx_from_lib("click", 1, -10)
	await get_tree().create_timer(0.04).timeout
	if !$AnimationPlayer.is_playing():
		if questionList[listNo][4] == false:
			$gameplayAudio.play_sfx_from_lib("pop", 1, -8)
			card.prev.questionSwitch.connect(_on_question_switch)
			card.next.questionSwitch.connect(_on_question_switch)
			card.close.pressed.connect(_on_close_card)
			
			# repositions the card to the global position of the selected question
			var questPos: Vector2 = parent.get_child(listNo).global_position
			card.position = questPos - Vector2(card.pivot_offset) + Vector2(pivot)
			card.anim.play("card_backflip")
			$AnimationPlayer.play("to_question")
			assign_card(listNo)
			currentItem = listNo
			
			await get_tree().create_timer(0.6).timeout
			
			# resets the card back to its original position as it zooms in.
			var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(bgm, "volume_db", -18.0, 0.8)
			tween.parallel().tween_property(card, "position", Vector2(offset - card.pivot_offset.x, 280.0), 0.3)
			$gameplayAudio.play_sfx_from_lib("flip", 1 + randf_range(-0.08, 0.08), -14)
			await $AnimationPlayer.animation_finished
			hintDialog.emit()
			tween.stop()
		else:
			$gameplayAudio.play_sfx_from_lib("miss", 1 + randf_range(-0.08, 0.08), -20)

func _on_question_switch(val): # switches questions left and right
	if !card.anim.is_playing():
		card.anim.play("card_doubleflip")
		$gameplayAudio.play_sfx_from_lib("doubleflip", 1 + randf_range(-0.08, 0.08), -12)
		await get_tree().create_timer(0.3).timeout
		currentItem = wrapi(currentItem + val, 0, 30) # loops back to all questions in the array
		while questionList[currentItem][4] == true: # prevents going back to already checked questions.
			currentItem = (currentItem + val) % 30
		
		card.checked = questionList[currentItem][4]
		_questions_update()
		assign_card(currentItem)
		hintDialog.emit()

func _on_answer_update(no): # on-screen keyboard (HFlowContainer) and its functions
	$gameplayAudio.play_sfx_from_lib("type", 1 + randf_range(-0.08, 0.08), -20)
	match no:
		5: # backspace
			if !card.answer == "":
				card.answer = card.answer.left(-1)
			else:
				$gameplayAudio.play_sfx_from_lib("miss", 1, -20)
		11: # check answer
			if card.answer != "" && !questionList[currentItem][4]: # ensures that you have an answer ready
				$StarParticles.emitting = true
				$gameplayAudio.play_sfx_from_lib("checked", 1.0, -20)
				
				questionList[currentItem][4] = true
				ticked += 1
				questionList[currentItem][3] = card.answer
				card.checked = true
				updateCard.connect(card._change_info)
				updateCard.emit()
				updateCard.disconnect(card._change_info)
				_check_answer(questionList[currentItem][0], questionList[currentItem][1], questionList[currentItem][2], int(questionList[currentItem][3]))
				card.anim.play("card_checked")
				if ticked < 30: # occurs until every single question is checked, switches questions until then.
					await get_tree().create_timer(0.6).timeout
					_on_question_switch(1)
					return
				else:
					bgm.stop()
					var playback = %charHead.tree["parameters/playback"]
					playback.travel("completed")
					%charState.process_mode = Node.PROCESS_MODE_DISABLED
					countdown.stop = true
					countdown.alert.stop()
					countdown.flip.stop()
					countdown.timeOut.disconnect(_on_time_out)
					card.prev.questionSwitch.disconnect(_on_question_switch)
					card.next.questionSwitch.disconnect(_on_question_switch)
					card.close.pressed.disconnect(_on_close_card)
					%DialogManager.queue_free()
					$gameplayAudio.play_sfx_from_lib("done", 1, 0)
					finalTime = countdown.time
					await card.anim.animation_finished
					await get_tree().create_timer(0.5).timeout
					_on_game_finished()
					return
			else:
				$gameplayAudio.play_sfx_from_lib("miss", 1, -20)
	
	if card.answer.length() < 5 && !questionList[currentItem][4]: # this limits the answers up to 5 digits.
		var typedNo: int
		match no:
			0:
				typedNo = 1
			1:
				typedNo = 2
			2:
				typedNo = 3
			3:
				typedNo = 4
			4:
				typedNo = 5
			6:
				typedNo = 6
			7:
				typedNo = 7
			8:
				typedNo = 8
			9:
				typedNo = 9
			10:
				typedNo = 0
		
		if card.answer == "0": # used if your input is zero. prevents multiple zeros at the same time.
			card.answer = str(typedNo)
		else:
			if !no == 5 and !no == 11:
				card.answer += str(typedNo)
	else:
		$gameplayAudio.play_sfx_from_lib("miss", 1, -20)
	updateCard.connect(card._change_info)
	updateCard.emit()
	updateCard.disconnect(card._change_info)

func _on_close_card(): # runs if the card is being closed
	_questions_update()
	if !$AnimationPlayer.is_playing():
		card.next.questionSwitch.disconnect(_on_question_switch)
		card.prev.questionSwitch.disconnect(_on_question_switch)
		card.close.pressed.disconnect(_on_close_card)
		
		$AnimationPlayer.play("from_question")
		var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		
		tween.tween_property(get_node("Card"), "position", Vector2(offset - card.pivot_offset.x + 32, 280.0), 0.25)
		tween.tween_property(get_node("Card"), "position", Vector2(-800, 280.0), 0.4)
		tween.parallel().tween_property(bgm, "volume_db", -10.0, 0.8)
		await get_tree().create_timer(0.25).timeout
		$gameplayAudio.play_sfx_from_lib("slide", 1 + randf_range(-0.08, 0.08), -16)

func _questions_update(): # updates the questions in the ddBackground to reflect user's answers
	var loop: int = 0
	for child in parent.get_children():
		child.answer = "%s" % str(questionList[loop][3])
		child.checked = questionList[loop][4]
		loop += 1

func _check_answer(firstInt: float, secondInt: float, operation: int, finalAns: float): # this function streamlines the checking process
	var finalInt: float
	
	match operation:
		0:
			finalInt = firstInt + secondInt
		1:
			finalInt = firstInt - secondInt
		2:
			finalInt = firstInt * secondInt
		3:
			finalInt = firstInt / secondInt
	
	if (int(finalAns) == int(finalInt)):
		correctAns += 1

func _on_warning():
	bgm["parameters/switch_to_clip"] = "hurry"
	countdown.timeOut2.disconnect(_on_warning)

func _on_game_finished():
	gameInfo[0] = opType
	gameInfo[1] = initTime
	gameInfo[2] = finalTime
	gameInfo[3] = correctAns
	gameInfo[4] = lvl
	gameInfo[5] = target
	
	var qtnArray = []
	for i in range(questionList.size()):
		var qtnFormat = questionList[i]
		qtnFormat.resize(4)
		if qtnFormat[3] == "":
			qtnFormat[3] = -1
		else:
			qtnFormat[3] = int(qtnFormat[3])
		
		var qtnNew: PackedInt32Array = qtnFormat
		qtnArray.append(qtnNew)
	gameplayComplete.emit(gameInfo, qtnArray)

func _on_time_out():
	var playback = %charHead.tree["parameters/playback"]
	
	playback.travel("finished")
	$AnimationPlayer.play("time_out")
	%DialogManager.queue_free()
	bgm.stop()
	countdown.flip.stop()
	await $AnimationPlayer.animation_finished
	_on_game_finished()

func _on_pause_button_pressed() -> void:
	bgm.stop()
	%charHead.tree.active = false
	%charState.process_mode = Node.PROCESS_MODE_DISABLED
	
	countdown.stop = true
	countdown.alert.stop()
	countdown.timeOut.disconnect(_on_time_out)
	countdown.flip.stop()
	%DialogManager.queue_free()
	$AnimationPlayer.play("on_pause")
	$gameplayAudio.play_sfx_from_lib("pause", 1, -12)

func _on_retry_pressed() -> void:
	retry.connect(get_tree().current_scene._on_retry)
	retry.emit()
	retry.disconnect(get_tree().current_scene._on_retry)

func _on_quit_pressed() -> void:
	quit.connect(get_tree().current_scene._on_levels)
	quit.emit()
	quit.disconnect(get_tree().current_scene._on_levels)
