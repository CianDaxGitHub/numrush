extends DialogState
class_name Cheer

var dialog = [
	["you can do it!"],
	["i believe in you!"],
	["practice makes perfect in this game of speed and wit!"],
	["reach for the top! you can do this!"],
	["i'll cheer you on whether you fail++ or succeed!"],
	["don't discourage yourself,++ making mistakes are a part of this game sometimes."],
	["the best thing you can achieve here is learning++ while having fun!"],
	["math can be quite tricky, but you can make it a breeze someday!"],
	["hang in there! you can race past time!"],
	["remember to take a break sometimes,++ your mind needs to refresh before continuing!"],
	["if you can solve them easily,++ then maybe you can solve them faster!"],
	["try not to get carried away!++ even engines need some time to cool down!"],
	["i want you to know that us robots consist of a series of both zeros and ones."],
	[
		"choose your questions wisely while playing.",
		"the questions you're familiar with can help you achieve faster times!"
	],
	["don't be afraid if you fail. you can always try again sometime!"],
	["maybe someday,++ you can achieve better scores in your own class!"],
	["if you're having any trouble, try tackling an easier problem!"],
	[
		"don't worry if you have any trouble with this.",
		"you'll eventually get better at this if you keep trying!",
	],
	[
		"you can repeat as many times as you want here,+ no problem.",
		"so when a real challenge comes your way,++ you can prepare yourself for it easily!"
	],
	[
		"if you feel frustrated,+ try to pause the game first.",
		"sure,+ you can only try a new set of questions when you resume.",
		"but once these questions pop up again,++ you can solve them with a fresh state of mind!"
	],
	[
		"if you needed me for help,++ that shouldn't be a laughing matter.",
		"don't let the others make you think that it is.",
		"even experts have trouble with simple math problems sometimes!++",
		"however,++ if you're using me while you're still taking a quiz or an exam,",
		"then that's the one thing that i can't allow you to do!",
		"otherwise, you're completely fine with asking me for help."
	],
	[
		"i do have to apologize if the questions seem... repetitive.",
		"i may not have the best programming when it comes to making questions.",
		"especially when it comes to simple operations.",
		"however,++ there's a bit of merit to it,",
		"these repeating questions+ allow you to solve them faster when they show up again.",
		"they allow you to make connections and patterns,++ contained within the numbers,",
		"and they can help you solve newer problems with ease afterwards!",
		"maybe,++ this whole thing is by design after all."
	],
	[
		"when you're taking a quiz or an exam,++ try to think of different patterns and solutions.",
		"when you can easily conceptualize them,++ through repetition++ and trial and error,",
		"maybe,++ these difficult questions,++ might contain simpler answers!"
	],
	[
		"if you can't answer everything immediately,",
		"you can easily check their solutions afterwards!",
		"don't worry,++ i wouldn't judge you because of it."
	],
	[
		"in the future,+ you'll be dealing with numbers multiplied by itself... a lot.",
		"it should be common practice in future topics in math when you grow up.",
		"there's also such a thing as a number multiplied by itself,++ twice!++ even more!"
	]
]

var dialog_exp = [
	[[0, 3, 1, 0]], # you can do it
	[[0, 3, 1, 0]], # believe
	[[0, 4, 1, 0]], # preactice
	[[2, 3, 1, 0]], # top
	[[0, 0, 1, 0]], # fail or succeed
	[[1, 3, 9, 0]], # making mistakes
	[[0, 0, 9, 0]], # learning and fun
	[[3, 4, 1, 0]], # tricky
	[[2, 3, 1, 0]], # race past time
	[[1, 3, 9, 0]], # take a break
	[[2, 3, 1, 0]], # easily and faster
	[[4, 0, 11, 2]], # engines
	[[1, 3, 1, 0]], # 0 and 1
	[[0, 0, 9, 0], [0, 3, 9, 0]], # choose your questions, faster times
	[[2, 3, 1, 0]], # try again sometime
	[[1, 3, 1, 0]], # your own class
	[[0, 0, 1, 0]], # tackle easier problems
	[[0, 0, 9, 0], [0, 3, 1, 0]], # have any trouble, you'll get better
	[[0, 0, 9, 0], [2, 4, 1, 0]], # many times, real challenge
	[[0, 0, 9, 0], [0, 0, 11, 2], [0, 0, 9, 0]], # pause the game, new set, popup again
	[[0, 0, 11, 2], [0, 0, 11, 2], [1, 3, 1, 0], [4, 0, 11, 2], [2, 2, 7, 2], [0, 0, 9, 0]], # no laughing matter
	[[1, 0, 11, 2], [1, 2, 11, 2], [1, 5, 11, 2], [0, 0, 11, 2], [0, 0, 11, 2], [0, 0, 9, 0], [0, 3, 9, 2], [0, 5, 9, 0]], # repetition
	[[0, 0, 9, 0], [0, 0, 9, 0], [0, 0, 1, 0]], # quiz and exams
	[[0, 0, 11, 2], [0, 0, 9, 0], [1, 3, 9, 0]], # check the solutions
	[[4, 2, 11, 2], [4, 0, 11, 2], [2, 6, 7, 2]] # numbers multiplied by itself
]
var dialogChoice
var dialog_index = 0

@onready var manager = %DialogManager

@onready var countdown = %Countdown
@onready var charHead = %charHead
@onready var playback

func enter():
	playback = charHead.tree["parameters/playback"]
	manager.dialogRefresh.connect(_on_dialog_refresh)
	manager.startAnim.connect(_on_dialog_start)
	manager.stopAnim.connect(_on_dialog_stop)
	manager.finished.connect(_on_finished)
	dialogChoice = randi_range(0, dialog.size() - 1)
	dialog_index = 0
	
	_switch_talk_expression()
	
	var finalLines: Array[String]
	
	if countdown.time > 60:
		playback.travel("bob")
	else:
		playback.travel("bob_hurry")
	
	for i in range(dialog[dialogChoice].size()):
		finalLines.append(dialog[dialogChoice][i])
	
	manager.start_dialog(Vector2(189, 27), finalLines)

func _on_dialog_refresh():
	dialog_index += 1
	_switch_talk_expression()

func _on_dialog_start():
	playback.travel("talk")

func _on_dialog_stop():
	playback.travel("talk_end")

func _switch_talk_expression():
	charHead.browSpeech = dialog_exp[dialogChoice][dialog_index][0]
	charHead.eyeSpeech = dialog_exp[dialogChoice][dialog_index][1]
	charHead.mouthOpen = dialog_exp[dialogChoice][dialog_index][2]
	charHead.mouthClose = dialog_exp[dialogChoice][dialog_index][3]

func _on_finished():
	manager.dialogRefresh.disconnect(_on_dialog_refresh)
	manager.startAnim.disconnect(_on_dialog_start)
	manager.stopAnim.disconnect(_on_dialog_stop)
	manager.finished.disconnect(_on_finished)
	switched.emit(self, "idle")
