extends Control

var initTime: float = 100
var time: float
var minute: int
var sec: int
var stop: bool = true
var pitch: float = 1
@onready var alert = %timerAlert
@onready var flip = $flipWatch
@onready var label = $Panel/Panel3/Time

signal timeOut()
signal timeOut2()

func _ready() -> void:
	$"../".gameInit.connect(_on_init)

func _process(delta: float) -> void:
	if !stop == true:
		if time > 0:
			time -= delta
		else:
			time = 0
			stop = true
		
		check_time(time)

func _on_init():
	var tween: Tween = get_tree().create_tween()
	tween.tween_method(Callable(self, "check_time"), int(initTime/10), initTime, 0.9).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	time = initTime
	if initTime > 60:
		alert.wait_time = initTime - 60
	else:
		_time_alert()
	alert.start()
	await get_tree().create_timer(0.75).timeout
	_flip_watch()
	flip.start()
	await get_tree().create_timer(0.25).timeout
	stop = false

func _flip_watch() -> void: # flips the watch. simple.
	flip.wait_time = 1.0
	flip.start()
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(get_node("Panel/Panel2/HourglassShadow"), "rotation", PI, 0.4).from(0)
	tween.parallel().tween_property(get_node("Panel/Panel2/Hourglass"), "rotation", PI, 0.4).from(0)

func _time_flicker() -> void: # the flickering of the timer, used as a visual warning
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label, "modulate", Color(0.866, 0, 0.261), 0.12)
	tween.parallel().tween_property(get_node("Panel/Panel2/Hourglass"), "modulate", Color(0.866, 0, 0.261), 0.12)
	tween.tween_property(label, "modulate", Color(1, 1, 1), 0.35)
	tween.parallel().tween_property(get_node("Panel/Panel2/Hourglass"), "modulate", Color(1, 1, 1), 0.35)

func _time_alert() -> void: # conditions used depending on how much time you have left
	if int(time) <= 11:
		timeOut2.emit()
		for i in range(10):
			$PolyAudio.play_sfx_from_lib("tick", pitch, -12)
			_time_flicker()
			pitch += 0.0365
			await get_tree().create_timer(1).timeout
			if stop:
				break
		
		if !stop:
			$PolyAudio.play_sfx_from_lib("tick", pitch, -12)
			$PolyAudio.play_sfx_from_lib("timeUp", 1, -6)
			_time_flicker()
			timeOut.emit()
	elif int(time) > 11 and int(time) <= 61:
		alert.wait_time = time - 11
		timeOut2.emit()
		alert.start()
		$PolyAudio.play_sfx_from_lib("alert", pitch, -4)
		for i in range(2):
			_time_flicker()
			await get_tree().create_timer(0.5).timeout
		pitch = 1

func check_time(newTime):
	sec = int(fmod(newTime, 60))
	minute = int(fmod(newTime, 3600) / 60)
	label.text = ("%02d:" % minute) + ("%02d" % sec)

func _on_timer_alert_timeout() -> void:
	_time_alert()
