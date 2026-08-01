extends DialogState
class_name Hint

@onready var main = $"../../"
@onready var manager = %DialogManager
@onready var card = %Card

@onready var charHead = %charHead
@onready var playback

var dialogAdd: Array = [
	[
		"if the same two numbers are swapped,+ maybe the answer could be the same as before!"
	],
	[
		"for this sort of problem,+ two numbers can borrow from each other to make them even.",
		"that way, it becomes as easy as adding a number by itself!"
	],
	[
		"if you feel stuck on larger numbers,+ try something like this.",
		"take a number,+ like 19 for example.++ break it up into two different numbers.",
		"add 10 first, and then 9. makes it easier, isn't it?",
		"now, try up to the hundreds.+ breaking them down makes it easier!"
	],
	[
		"there's nothing simpler than counting upwards... even if it takes longer."
	],
	[
		"this could be useful for adding larger numbers.",
		"if the right number at the top exceeds nine,+ you can count again from zero.",
		"every time you repeat,+ you can add one from the number on its left side!",
		"however,+ the opposite happens when it comes to subtraction.",
		"you can count again from nine to zero,+ but if you repeat,+ you take away one instead!"
	],
	[
		"imagine a line,+ marked with numbers counting upwards from zero+ to as long as you want.",
		"pick the top number of the problem+ and visualize it on the line.",
		"then,+ count to your right by the bottom number of the problem to get the result!"
	]
]

var dialogSub: Array = [
	[
		"this could be useful for subtracting larger numbers.",
		"if the right number at the top exceeds zero,+ you can count again from nine.",
		"every time you repeat,+ you can take away one from the number on its left side!",
		"however,+ the opposite happens when it comes to addition.",
		"you can count again from zero to nine,+ but for every repeat,+ you give one instead!"
	],
	[
		"it's completely empty if you take away the same number by itself."
	],
	[
		"there's nothing simpler than counting downwards... even if it takes longer."
	],
	[
		"imagine a line,+ marked with numbers counting upwards from zero+ to as long as you want.",
		"pick the top number of the problem+ and visualize it on the line.",
		"then,+ count to your left by the bottom number of the problem to get the result!"
	],
	[
		"there's a limit to how much you can give to someone else.",
		"let's say the bottom number is your limit,",
		"once you reach it, you can keep the remainders for yourself.",
		"that's how subtraction works!"
	],
	[
		"if you feel stuck on larger numbers,+ try something like this.",
		"take a number,+ like 19 for example.++ break it up into two different numbers.",
		"subtract 9 first, and then 10. makes it easier, isn't it?",
		"now, try up to the hundreds.+ breaking them down makes it easier!"
	],
	[
		"here's a tip to subtract two-digit numbers from a number with three.",
		"after subtracting by the ones place on the right,",
		"you can then treat the leftmost numbers as a single digit.",
		"125 becomes 12 and 5.++ subtract 12 by the tens digit on the left,+ and you have the result!"
	]
]

var dialogMul: Array = [
	[
		"if the same two numbers are swapped,+ maybe the answer could be the same as before!"
	],
	[
		"in certain operations,+ certain numbers prevent the results from changing!"
	],
	[
		"when multiplying,+ think about adding a number a few times."
	],
	[
		"it's said that the rightmost number has a peculiar pattern.",
		"starting from one to ten, multiply a number by three.++ three... six... nine...",
		"now, let's multiply the last few numbers by seven,",
		"the rightmost number goes the opposite way.++ nine... six... three... you see the pattern?"
	],
	[
		"multiplying by two is as simple as adding a number by itself.",
		"don't believe me?++ try to check the results."
	],
	[
		"if you were to multiply a number by ten.++ it would be like a larger version of one to three!"
	],
	[
		"i think division and multiplication are connected together.",
		"imagine this.++ if the large number is the result,",
		"then what would be the missing piece to get to that number?"
	],
	[
		"if you were to take a number and multiply by 10,",
		"it's the same number,+ with an added zero on the right!",
		"and if you were to multiply by 5,++ just divide that value by 2,+ and you''ll get the same result!",
		"if something is close to either 5 or 10,++ like multiplying by 6 or 9,",
		"then you can add or subtract the base number from those x5 or x10 values.",
		"maybe you can tackle larger numbers with that!"
	],
	[
		"when dealing with numbers multiplied by itself,",
		"there's a pattern that emerges with succeeding numbers.",
		"think of a number like 5 for example,++ 5 times itself is equal to 25.",
		"take 25,++ then add 5 twice,++ and then add 1.",
		"that gives you the number of 6 multiplied by itself!++ fascinating, isn't it?"
	],
	[
		"i thought of a trick to make huge numbers easier to multiply.",
		"take the top number,++ and multiply it by 2.++ then,+ try to count every 2 steps this time.",
		"with it,+ you can reach the bottom number a lot faster this way,",
		"all while you keep adding the doubled top number by itself!",
		"if the bottom number is an odd number,++ then you can add the base top number once."
	],
	[
		"for two digit numbers multiplied by a single digit number,++ try this crazy method.",
		"multiply each digit by the bottom number,++ then type the two results here from left to right.",
		"when you add and combine the two middle numbers from the resulting text,",
		"this is where you'll get the final answer!",
		"just like in addition,+ if the sum of these two numbers reach up to the tens,",
		"then add 1 to the leftmost number.",
		"the chances of this method working are around 65 percent.++ 70... 80... who knows,+ try it out!"
	]
]

var dialogDiv: Array = [
	[
		"in certain operations,+ certain numbers prevent the results from changing!"
	],
	[
		"if you have nine pencils,+ how many times can you give three before you run out?"
	],
	[
		"you can easily determine if a number is even if you can divide it equally by two."
	],
	[
		"if you divide a number by larger numbers, the result gets smaller and smaller!",
		"if that's the case,+ i wonder if you can make numbers larger when divided...",
		"wait,++ what if you were to divide by zero?++ would it be as large as the universe?!"
	],
	[
		"i think division and multiplication are connected together.",
		"imagine this.++ if the large number is the result,",
		"then what would be the missing piece to get to that number?"
	],
	[
		"there's only one thing you can get from dividing a number by itself."
	]
]

var questions: Array[String] = [
	"you know,+ i've always been wondering.",
	"think about this for a second.",
	"hey, you got a minute?+ i wanted to ask."
] # beginning dialog used if the very last symbol of a chosen dialog is "?"

var thoughts: Array[String] = [
	"listen,+ i think this could be useful.",
	"here's a little thought from me.",
	"psst... over here... i got something to tell you."
] # beginning dialog used if the very last symbol of a chosen dialog is "."

var exclamations: Array[String] = [
	"i just thought of something.",
	"so,++ i just thought of an idea.",
	"here's something that could help."
] # beginning dialog used if the very last symbol of a chosen dialog is "!"

var stateTime: float
var stateList = ["cheer", "timecheck"]
var clicked: bool = false

var thoughts_exp = [
	[0, 0, 9, 0], # useful
	[0, 0, 9, 0], # little thought
	[0, 0, 9, 0] # over here
]

var questions_exp = [
	[0, 0, 11, 2], # wondering
	[0, 0, 11, 2], # think about this
	[4, 0, 11, 2] # got a minute
]

var exclamations_exp = [
	[0, 0, 9, 0], # thought of something
	[0, 0, 9, 0], # an idea
	[0, 0, 9, 0] # that could help
]

var dialogAdd_exp = [
	[[0, 0, 11, 2]], # two numbers are swapped
	[[0, 0, 9, 0], [0, 3, 1, 0]], # borrowing numbers
	[[2, 2, 9, 0], [1, 2, 1, 0], [0, 0, 9, 0], [2, 0, 1, 0]], # split the numbers
	[[2, 2, 9, 0]], # counting up
	[[0, 0, 11, 2], [0, 0, 9, 0], [0, 3, 9, 0], [0, 0, 11, 2], [0, 0, 1, 0]], # adding larger numbers
	[[0, 2, 9, 0], [2, 2, 9, 0], [0, 0, 1, 0]] # imagine a line
]

var dialogSub_exp = [
	[[0, 0, 11, 2], [0, 0, 9, 0], [0, 3, 9, 0], [0, 0, 11, 2], [0, 0, 1, 0]], # subtracting larger numbers
	[[4, 2, 11, 2]], # empty
	[[2, 2, 9, 0]], # counting down
	[[0, 2, 9, 0], [2, 2, 9, 0], [0, 0, 1, 0]], # imagine a line
	[[0, 0, 11, 2], [2, 2, 11, 2], [2, 2, 9, 0], [2, 3, 1, 0]], # there's a limit
	[[2, 2, 9, 0], [1, 2, 1, 0], [0, 0, 9, 0], [2, 0, 1, 0]], # split the numbers
	[[0, 0, 9, 0], [0, 0, 11, 2], [0, 0, 9, 0], [2, 2, 1, 0]] # two from three
]

var dialogMul_exp = [
	[[0, 0, 1, 0]], # swap the numbers
	[[0, 0, 1, 0]], # prevent changing
	[[2, 2, 11, 2]], # adding numbers
	[[1, 2, 11, 2], [0, 0, 11, 2], [2, 2, 11, 2], [2, 0, 11, 2]], # peculiar pattern
	[[0, 3, 9, 0], [3, 4, 1, 0]], # adding numbers 2
	[[0, 0, 1, 0]], # power of 10
	[[3, 0, 11, 2], [0, 2, 11, 2], [3, 0, 7, 2]], # division and multiplication
	[[0, 0, 9, 0], [0, 0, 1, 0], [2, 0, 1, 0], [0, 0, 11, 2], [0, 0, 9, 0], [3, 0, 1, 0]], # multiply by 10 or 5
	[[0, 0, 11, 2], [1, 2, 11, 2], [2, 2, 11, 2], [2, 0, 11, 2], [2, 0, 1, 0]], # multiplied by itself
	[[2, 0, 1, 0], [0, 0, 9, 0], [3, 0, 9, 0], [0, 0, 1, 0], [0, 0, 11, 2]], # skip count by 2
	[[2, 6, 1, 0], [2, 0, 9, 0], [2, 2, 9, 0], [2, 6, 1, 0], [2, 0, 11, 2], [2, 2, 9, 0], [2, 0, 1, 0]], # crazy 2 middle numbers method
]

var dialogDiv_exp = [
	[[0, 0, 1, 0]], # prevent changing
	[[0, 0, 7, 2]], # pencils
	[[0, 0, 9, 0]], # even numbers
	[[0, 0, 9, 0], [3, 0, 11, 2], [0, 6, 7, 6]], # the divisor
	[[3, 0, 11, 2], [0, 2, 11, 2], [3, 0, 7, 2]], # division and multiplication
	[[2, 2, 11, 2]], # dividing by itself
]

var dialogChoice

@onready var countdown = %Countdown

var final_exp = []
var final_index = 0

func enter():
	_alert()
	final_index = 0
	final_exp = []
	
	playback = charHead.tree["parameters/playback"]
	clicked = false
	stateTime = randi_range(3, 7)
	main.hintDialog.connect(_on_clicked)
	countdown.timeOut2.connect(_on_hurry)
	
	manager.dialogRefresh.connect(_on_dialog_refresh)
	manager.startAnim.connect(_on_dialog_start)
	manager.stopAnim.connect(_on_dialog_stop)
	manager.finished.connect(_on_finished)

func _alert():
	for i in range(2):
		var tween = get_tree().create_tween()
		%gameplayAudio.play_sfx_from_lib("hint", 1.2, -14, 0.0)
		tween.tween_property(charHead, "modulate", Color(1.3, 1.3, 1.3), 0.1)
		tween.tween_property(charHead, "modulate", Color(1.0, 1.0, 1.0), 0.3)
		await get_tree().create_timer(0.4).timeout

func update(_delta: float) -> void:
	if clicked == true:
		return
	else:
		if stateTime > 0:
			stateTime -= _delta
		else:
			switched.emit(self, stateList[randi_range(0, 1)])

func _on_clicked():
	main.hintDialog.disconnect(_on_clicked)
	countdown.timeOut2.disconnect(_on_hurry)
	final_index = 0
	final_exp = []
	clicked = true
	var dialogIndex
	var lastSentence: String
	var finalLines: Array[String]
	
	var op = card.operation
	
	match op:
		0:
			dialogIndex = randi_range(0, (dialogAdd.size() - 1))
			lastSentence = dialogAdd[dialogIndex][dialogAdd[dialogIndex].size() - 1]
			for i in range(dialogAdd[dialogIndex].size()):
				finalLines.append(dialogAdd[dialogIndex][i])
				final_exp.append(dialogAdd_exp[dialogIndex][i])
		1:
			dialogIndex = randi_range(0, (dialogSub.size() - 1))
			lastSentence = dialogSub[dialogIndex][dialogSub[dialogIndex].size() - 1]
			for i in range(dialogSub[dialogIndex].size()):
				finalLines.append(dialogSub[dialogIndex][i])
				final_exp.append(dialogSub_exp[dialogIndex][i])
		2:
			dialogIndex = randi_range(0, (dialogMul.size() - 1))
			lastSentence = dialogMul[dialogIndex][dialogMul[dialogIndex].size() - 1]
			for i in range(dialogMul[dialogIndex].size()):
				finalLines.append(dialogMul[dialogIndex][i])
				final_exp.append(dialogMul_exp[dialogIndex][i])
		3:
			dialogIndex = randi_range(0, (dialogDiv.size() - 1))
			lastSentence = dialogDiv[dialogIndex][dialogDiv[dialogIndex].size() - 1]
			for i in range(dialogDiv[dialogIndex].size()):
				finalLines.append(dialogDiv[dialogIndex][i])
				final_exp.append(dialogDiv_exp[dialogIndex][i])
	
	var sentenceType: String = lastSentence.substr(lastSentence.length() - 1)
	
	match sentenceType:
		".":
			var ind = randi_range(0, 2)
			finalLines.push_front(thoughts[ind])
			final_exp.push_front(thoughts_exp[ind])
		"?":
			var ind = randi_range(0, 2)
			finalLines.push_front(questions[ind])
			final_exp.push_front(questions_exp[ind])
		"!":
			var ind = randi_range(0, 2)
			finalLines.push_front(exclamations[ind])
			final_exp.push_front(exclamations_exp[ind])
	
	_switch_talk_expression()
	manager.start_dialog(Vector2(189, 27), finalLines)
	if countdown.time > 60:
		playback.travel("bob")
	else:
		playback.travel("bob_hurry")

func _on_hurry():
	if countdown.time <= 11:
		stateTime = 20
		playback.travel("timer")
	elif countdown.time <= 62:
		playback.travel("idle_hurry")
		stateTime = randi_range(2, 4)

func _on_dialog_refresh():
	final_index += 1
	_switch_talk_expression()

func _on_dialog_start():
	playback.travel("talk")

func _on_dialog_stop():
	playback.travel("talk_end")

func _switch_talk_expression():
	charHead.browSpeech = final_exp[final_index][0]
	charHead.eyeSpeech = final_exp[final_index][1]
	charHead.mouthOpen = final_exp[final_index][2]
	charHead.mouthClose = final_exp[final_index][3]

func _on_finished():
	if main.hintDialog.is_connected(_on_clicked):
		main.hintDialog.disconnect(_on_clicked)
		countdown.timeOut2.disconnect(_on_hurry)
	
	manager.dialogRefresh.disconnect(_on_dialog_refresh)
	manager.startAnim.disconnect(_on_dialog_start)
	manager.stopAnim.disconnect(_on_dialog_stop)
	manager.finished.disconnect(_on_finished)
	switched.emit(self, "idle")
