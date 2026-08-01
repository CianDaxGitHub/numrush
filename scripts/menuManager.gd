extends Control

var _menu_state: String = "menu"

@onready var currentLevel
@onready var gameSetup = [0, 0, 0, 0, 0, 0, 0] # type (operations), lvl, time, 1st random max, 2nd random max, target, prob

@onready var bg = $Background

@onready var bgm: AudioStreamPlaybackInteractive = $menuBGM.get_stream_playback()

signal passGameSetup(setup)

var menu_pos = {
	"menu": Vector2(-1176, -1408),
	"shop": Vector2(-87, -1408),
	"records": Vector2(-2291, -1408),
	"tutorial": Vector2(-87, -69),
	"levels": Vector2(-1176, -69),
	"info": Vector2(-2291, -69),
	"avatar": Vector2(-87, -2772),
	"about": Vector2(-1176, -2772),
	"boards": Vector2(-2291, -2772)
} # list of all positions for the animated background

func _acquire_previous_setup(setup):
	gameSetup = setup

func _ready() -> void:
	bg.position = menu_pos[_menu_state]
	await get_tree().create_timer(0.4).timeout
	currentLevel = load("scenes/menu/" + _menu_state + ".tscn").instantiate()
	add_child(currentLevel)
	_load_menu_signals(currentLevel)
	bgm.switch_to_clip_by_name(&"main")
	
	match _menu_state:
		"levels":
			currentLevel.level_select.connect(_on_level_select)
		"info":
			currentLevel.gameTransfer.connect(_on_game_transfer)

func _menu_button_pressed(button):
	_unload_menu_signals(currentLevel)
	await get_tree().create_timer(0.3).timeout
	# tweens from the old menu to the new menu
	var toState = button.toState
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	var nextLevel
	
	tween.tween_property(bg, "position", menu_pos[toState], 1).from(menu_pos[_menu_state])
	tween.parallel().tween_property(currentLevel, "global_position", Vector2((menu_pos[toState].x - menu_pos[_menu_state].x), (menu_pos[toState].y - menu_pos[_menu_state].y)), 1)
	match _menu_state: # determines the final game setup based on the current menu
			"menu":
				match toState:
					"levels":
						gameSetup[0] = button.gameChoice
			"levels":
				match toState:
					"menu":
						gameSetup[1] = -1
						gameSetup[2] = 0
						gameSetup[3] = 0
						gameSetup[4] = 0
						gameSetup[5] = 0
						gameSetup[6] = 0
	
	nextLevel = load("scenes/menu/" + toState + ".tscn").instantiate()
	
	if toState == "levels":
		nextLevel.level_select.connect(_on_level_select)
	else:
		if _menu_state == "levels":
			currentLevel.level_select.disconnect(_on_level_select)
	
	if toState == "info":
		nextLevel.gameTransfer.connect(_on_game_transfer)
	else:
		if _menu_state == "info":
			currentLevel.gameTransfer.disconnect(_on_game_transfer)
	
	if toState == "about":
		bgm.switch_to_clip_by_name(&"about")
		tween.parallel().tween_property($Background, "self_modulate", Color("9896ab"), 1.2)
	else:
		if _menu_state == "about":
			bgm.switch_to_clip_by_name(&"main")
			tween.parallel().tween_property($Background, "self_modulate", Color("ffffffff"), 1.2)
	
	_menu_state = toState
	
	await tween.finished
	
	add_child(nextLevel)
	currentLevel.queue_free()
	currentLevel = nextLevel
	_load_menu_signals(currentLevel)

func _load_menu_signals(scene): # loads every signal from children nodes with the class "MenuButtonState"
	for child in scene.find_children("*", "MenuButtonState", true):
		child.pressed.connect(_menu_button_pressed.bind(child))

func _unload_menu_signals(scene): # unloads every signal from children nodes with the class "MenuButtonState"
	for child in scene.find_children("*", "MenuButtonState", true):
		child.pressed.disconnect(_menu_button_pressed.bind(child))

func _on_level_select(level, time, fNo, sNo, target, prob) -> void:
	gameSetup[1] = level
	gameSetup[2] = time
	gameSetup[3] = fNo
	gameSetup[4] = sNo
	gameSetup[5] = target
	gameSetup[6] = prob

func _on_game_transfer():
	bgm.switch_to_clip_by_name(&"empty")
	passGameSetup.connect(get_tree().current_scene._on_values)
	passGameSetup.emit(gameSetup)
	passGameSetup.disconnect(get_tree().current_scene._on_values)
