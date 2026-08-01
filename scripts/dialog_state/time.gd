extends DialogState
class_name TimeCheck

var dialog = [
	"just %d more minutes left...",
	"%d minutes left, can you make it?",
	"you have %d minutes to reach your target score!",
	"%d minutes... it should be enough time to finish this!",
	"i wonder how much you can solve in just %d minutes?",
	"think you can handle these questions within %d minutes?",
	"in just %d minutes, the game will be finished.",
	"you can do it, you just have %d more minutes!"
]

var dialogHurry = [
	"1 minute left! you have to hurry!",
	"there's the final stretch! keep pushing!",
	"there's only 1 minute left! you can do this!",
	"less than 60 seconds remaining, can you achieve the target score?",
	"there's not much time, show us what you got!"
]

var dialog_exp = [
	[0, 0, 9, 0], # just more minutes left...
	[2, 0, 9, 0], # can you make it?
	[2, 0, 1, 0], # reach your target
	[2, 2, 9, 0], # enough time
	[3, 4, 1, 0], # how much can you solve
	[2, 0, 1, 0], # handle these questions
	[0, 0, 11, 2], # game finished
	[2, 0, 1, 0] # you can do it
]
var dialogHurry_exp = [
	[2, 0, 7, 1], # you have to hurry
	[2, 0, 11, 2], # the final stretch
	[0, 3, 9, 0], # you can do this
	[2, 4, 9, 0], # target score
	[2, 0, 9, 0] # show us what you got
]

var dialogChoice

var time

@onready var manager = %DialogManager
@onready var countdown = %Countdown

@onready var charHead = %charHead
@onready var playback

func enter():
	playback = charHead.tree["parameters/playback"]
	time = int(fmod(countdown.time, 3600) / 60)
	var sec = int(fmod(countdown.time, 60))
	var finalLines: Array[String]
	
	manager.startAnim.connect(_on_dialog_start)
	manager.stopAnim.connect(_on_dialog_stop)
	manager.finished.connect(_on_finished)
	
	
	if countdown.time > 60:
		playback.travel("bob")
	else:
		playback.travel("bob_hurry")
	
	if time > 0:
		dialogChoice = randi_range(0, dialog.size() - 1)
		_switch_talk_expression()
		if sec > 40:
			finalLines.append(dialog[dialogChoice] % (time + 1))
		else:
			finalLines.append(dialog[dialogChoice] % time)
			if time == 1:
				finalLines[0] = finalLines[0].replace("minutes", "minute")
	else:
		dialogChoice = randi_range(0, dialogHurry.size() - 1)
		_switch_talk_expression()
		finalLines.append(dialogHurry[dialogChoice])
	
	manager.start_dialog(Vector2(189, 27), finalLines)

func _on_dialog_start():
	playback.travel("talk")

func _on_dialog_stop():
	playback.travel("talk_end")

func _switch_talk_expression():
	if time > 0:
		charHead.browSpeech = dialog_exp[dialogChoice][0]
		charHead.eyeSpeech = dialog_exp[dialogChoice][1]
		charHead.mouthOpen = dialog_exp[dialogChoice][2]
		charHead.mouthClose = dialog_exp[dialogChoice][3]
	else:
		charHead.browSpeech = dialogHurry_exp[dialogChoice][0]
		charHead.eyeSpeech = dialogHurry_exp[dialogChoice][1]
		charHead.mouthOpen = dialogHurry_exp[dialogChoice][2]
		charHead.mouthClose = dialogHurry_exp[dialogChoice][3]

func _on_finished():
	manager.startAnim.disconnect(_on_dialog_start)
	manager.stopAnim.disconnect(_on_dialog_stop)
	manager.finished.disconnect(_on_finished)
	switched.emit(self, "idle")
