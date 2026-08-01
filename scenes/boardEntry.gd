extends Control

var entry: TaloLeaderboardEntry
@onready var panel_rank: Panel = %panelRank
@onready var rankText = %Rank
@onready var userText = %user
@onready var gender = %gender
@onready var highScoreText = %highScore
@onready var estTimeText = %estTime

@onready var anim: AnimationPlayer = %AnimationPlayer

var place: int
signal extend
signal retract

var extended = false

var genderImg = ["res://images/syrill/boy symbol.png", "res://images/syrill/girl symbol.png"]
@onready var panels = [preload("res://themes/gold.tres"), preload("res://themes/silver.tres"), preload("res://themes/bronze.tres"), preload("res://themes/reg.tres")]

var creationDate: Dictionary

func _set_rank(pos: int):
	panel_rank.add_theme_stylebox_override("panel", panels[clampi(pos, 0, 3)])
	rankText.text = str(pos + 1)

func _set_username(user: String):
	userText.text = user

func _set_gender(gnd: String):
	match gnd:
		"Male":
			gender.texture = load(genderImg[0])
		"Female":
			gender.texture = load(genderImg[1])

func _set_highscore(scr: String):
	highScoreText.text = scr

func _set_est_time(tme: float):
	var msec = int(fmod(tme, 1) * 100)
	var sec = int(fmod(tme, 60))
	var minute = int(fmod(tme, 3600) / 60)
	
	estTimeText.text = "%02d:%02d.%02d" % [minute, sec, msec]

func _set_creation_date(cre: String):
	var utc: int = Time.get_unix_time_from_datetime_string(cre)
	var time_zone = Time.get_time_zone_from_system()
	var bias_min: int = time_zone.bias
	
	var localTime = utc + (bias_min * 60)
	
	creationDate = Time.get_datetime_dict_from_unix_time(localTime)
	var month: int = creationDate["month"]
	var day: int = creationDate["day"]
	var year: int = creationDate["year"]
	var hour_24: int = creationDate["hour"]
	var hour_12: int = hour_24
	var minute: int = creationDate["minute"]
	var second: int = creationDate["second"]
	var ampm: String = ""
	
	if hour_24 >= 12:
		ampm = "PM"
		if hour_24 > 12:
			hour_12 -= 12
	else:
		ampm = "AM"
		if hour_24 == 0:
			hour_12 = 12
	
	%dateText.text = "Created on: %d/%d/%d - %02d:%02d:%02d%s" % [month, day, year, hour_12, minute, second, ampm]

func set_data() -> void:
	var player = entry.player_alias.player
	_set_rank(entry.position)
	_set_username(entry.player_alias.identifier)
	_set_gender(player.get_prop("gender"))
	_set_highscore(entry.get_prop("score"))
	_set_est_time(float(entry.get_prop("estTime")))
	_set_creation_date(entry.created_at)

func _ready():
	set_data()

func _extend():
	anim.play("extend")
	extended = true

func _retract():
	anim.play("retract")
	extended = false

func _on_entry_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if extended == false:
				extend.connect(_extend)
				extend.emit()
				extend.disconnect(_extend)
			else:
				retract.connect(_retract)
				retract.emit()
				retract.disconnect(_retract)
