extends Node

var loadList = ["res://scenes/menuManager.tscn", "res://scenes/mainGameplay.tscn", "res://scenes/results.tscn", "res://scenes/landing/accManager.tscn"]

var sceneList = {
	"loading": preload("res://scenes/loading.tscn")
}

var curStr = []

var status = 0

var offline

signal gameplayParameters(type)

var initScene: PackedScene = sceneList["loading"]
@onready var currentScene

var _gameSetup = [] # for initial parameters
var _gameInfo = [] # for the final results
var _questionList = []

@onready var level_progress = %levelProgress
@onready var clothing_status = %clothingStatus

func _ready() -> void:
	Talo.connection_lost.connect(_on_lost)
	Talo.connection_restored.connect(_on_restore)
	currentScene = initScene.instantiate()
	for i in loadList:
		currentScene.to_load.append("1")
		ResourceLoader.load_threaded_request(i)
	add_child(currentScene)
	offline = await Talo.is_offline()

func _process(_delta: float) -> void:
	for path in loadList:
		status = ResourceLoader.load_threaded_get_status(path)
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			currentScene.loaded.append("done")

func _on_lost():
	offline = true

func _on_restore():
	offline = false

func _on_loaded():
	sceneList["menu"] = ResourceLoader.load_threaded_get(loadList[0])
	sceneList["gameplay"] = ResourceLoader.load_threaded_get(loadList[1])
	sceneList["results"] = ResourceLoader.load_threaded_get(loadList[2])
	sceneList["account"] = ResourceLoader.load_threaded_get(loadList[3])
	Talo.player_auth.session_found.connect(_on_logged)
	Talo.player_auth.session_not_found.connect(_on_fresh)
	Talo.players.identification_failed.connect(_on_fresh)
	Talo.player_auth.start_session()

func _on_login():
	await _refresh_all()
	var saves = await Talo.saves.get_saves()
	Talo.saves.choose_save(Talo.saves.latest)
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("menu")
	$AnimationPlayer.play("up_to_black_out")

func _on_logged():
	currentScene.loadingText.text = "Identifying..."
	await Talo.players.identified
	var saves = await Talo.saves.get_saves()
	Talo.saves.choose_save(Talo.saves.latest)
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("menu")
	$AnimationPlayer.play("up_to_black_out")

func _on_fresh():
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("account")
	$AnimationPlayer.play("up_to_black_out")

func _on_signup(nme, a, gnd):
	await _refresh_all()
	await Talo.saves.create_save("save")
	Talo.current_player.set_prop("name", nme)
	Talo.current_player.set_prop("age", a)
	Talo.current_player.set_prop("gender", gnd)
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("menu")
	$AnimationPlayer.play("up_to_black_out")

func _on_logout():
	await Talo.saves.update_current_save()
	var _path = "user://history.save"
	DirAccess.remove_absolute(_path)
	await Talo.player_auth.logout()
	$AnimationPlayer.play("up_to_black_in")
	currentScene.bgm.switch_to_clip_by_name(&"empty")
	await $AnimationPlayer.animation_finished
	_scene_switch("account")
	$AnimationPlayer.play("up_to_black_out")

func _refresh_all():
	level_progress.refresh_data()
	clothing_status.refresh_data()

func _on_values(setup):
	_gameSetup = setup
	
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("gameplay")
	$AnimationPlayer.play("up_to_black_out")
	currentScene.gameplayComplete.connect(_on_gameplay_complete)

func _on_gameplay_complete(info, questions):
	_gameInfo = info
	_questionList = questions
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("results")
	$AnimationPlayer.play("up_to_black_out")

func _on_home():
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("menu")
	currentScene._menu_state = "menu"
	_gameSetup = []
	_gameInfo = []
	$AnimationPlayer.play("up_to_black_out")

func _on_levels():
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("menu")
	currentScene._menu_state = "levels"
	currentScene.bg.position = currentScene.menu_pos[currentScene._menu_state]
	gameplayParameters.connect(currentScene._acquire_previous_setup)
	gameplayParameters.emit(_gameSetup)
	gameplayParameters.disconnect(currentScene._acquire_previous_setup)
	_gameSetup = []
	_gameInfo = []
	$AnimationPlayer.play("up_to_black_out")

func _on_retry():
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("gameplay")
	_gameInfo = []
	$AnimationPlayer.play("up_to_black_out")
	currentScene.gameplayComplete.connect(_on_gameplay_complete)

func _on_next_level(type):
	var lvl = _gameSetup[2] + 1
	_gameSetup[0] = []
	_gameSetup[0] = type
	var res
	_gameSetup[1] = lvl
	match type:
		0:
			res = load("res://level_parameters/add/%d.tres" % (lvl))
	
	_gameSetup[2] = res.time
	_gameSetup[3] = res.firstMax
	_gameSetup[4] = res.secondMax
	_gameSetup[5] = res.target
	_gameSetup[6] = res.probability
	_gameInfo = []
	
	$AnimationPlayer.play("up_to_black_in")
	await $AnimationPlayer.animation_finished
	_scene_switch("gameplay")
	$AnimationPlayer.play("up_to_black_out")
	currentScene.gameplayComplete.connect(_on_gameplay_complete)

func _scene_switch(toScene: String):
	currentScene = sceneList[toScene].instantiate()
	
	if toScene == "gameplay":
		gameplayParameters.connect(currentScene._acquire_level_data)
		gameplayParameters.emit(_gameSetup)
		gameplayParameters.disconnect(currentScene._acquire_level_data)
	
	self.get_child(get_child_count() - 1).queue_free()
	self.add_child(currentScene)

func game_save():
	await Talo.saves.update_current_save()

func send_to_boards(boardName, boardScore, boardTotal, boardTime, boardLevel):
	await Talo.leaderboards.add_entry(boardName, boardScore, {score = boardTotal, estTime = boardTime, level = boardLevel})

func _on_item_bought(res):
	for i in range(clothing_status.resList.size()):
		if clothing_status.resList[i] == res:
			clothing_status.resList[i].bought = true
			level_progress.coins -= res.price
			break
	Talo.saves.update_current_save()

func _on_level_success(type) -> void:
	if _gameInfo[4] > level_progress.level_progress[type]:
		level_progress.level_progress[type] = clamp(level_progress.level_progress[type] + 1, 0, 9)
		await Talo.saves.update_current_save()
