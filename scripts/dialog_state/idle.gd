extends DialogState
class_name Idle

var stateTime: float
var stateList = ["cheer", "timecheck", "hint"]

@onready var blink: Timer = %blink
@onready var charHead: Node2D = %charHead
@onready var playback

@onready var countdown = %Countdown

func enter():
	playback = charHead.tree["parameters/playback"]
	
	if !blink.timeout.is_connected(_on_blink):
		blink.timeout.connect(_on_blink)
	
	if (countdown.time >= 80 and countdown.stop == false) or (countdown.time <= 60 and countdown.time >= 15 and countdown.stop == false) or (countdown.time == 0 and countdown.stop == true):
		stateTime = randi_range(8, 12)
	else:
		stateTime = 20
	
	if countdown.stop == false:
		if countdown.time < 11:
			playback.travel("timer")
		elif countdown.time < 60:
			playback.travel("hurry")
		else:
			playback.travel("idle")
			charHead._switch_expression(2, 0, 4)
			await get_tree().create_timer(0.2).timeout
			charHead._switch_expression(0)
			blink.wait_time = randi_range(3, 6)
			blink.start()
	
	countdown.timeOut2.connect(_on_hurry)

func _on_hurry():
	blink.stop()
	if countdown.time <= 11:
		stateTime = 20
		playback.travel("timer")
	elif countdown.time <= 62:
		playback.travel("idle_hurry")
		stateTime = randi_range(3, 5)

func _on_blink():
	blink.wait_time = randi_range(3, 6)
	blink.start()
	var chance: int = randi_range(0, 4)
	
	match chance:
		4:
			charHead._switch_expression(2)
			await get_tree().create_timer(0.1).timeout
			charHead._switch_expression(0)
			await get_tree().create_timer(0.3).timeout
			charHead._switch_expression(2)
			await get_tree().create_timer(0.1).timeout
			charHead._switch_expression(0)
		_:
			charHead._switch_expression(2)
			await get_tree().create_timer(0.1).timeout
			charHead._switch_expression(0)

func update(_delta: float) -> void:
	if stateTime > 0:
		stateTime -= _delta
	else:
		switched.emit(self, stateList[randi_range(0, 2)])

func exit():
	blink.stop()
	blink.timeout.disconnect(_on_blink)
	countdown.timeOut2.disconnect(_on_hurry)
