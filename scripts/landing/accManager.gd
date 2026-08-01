extends Control

var currentScene
var newScene

@onready var menuList = {
	"landing": preload("res://scenes/landing/landingPage.tscn"),
	"signup": preload("res://scenes/landing/accCreate.tscn"),
	"signin": preload("res://scenes/landing/signIn.tscn"),
}

@onready var initScene: PackedScene = menuList["landing"]

func _ready() -> void:
	currentScene = initScene.instantiate()
	add_child(currentScene)
	_load_signals(currentScene)
	

func _menu_button_pressed(button):
	var toState = button.toState
	var nextScene
	
	_unload_signals(currentScene)
	await get_tree().create_timer(0.5).timeout
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	var viewportRect = get_viewport_rect()
	
	
	tween.tween_property(currentScene, "global_position", Vector2(-viewportRect.size.x, 0), 0.5)
	await tween.finished
	tween.stop()
	
	nextScene = menuList[toState].instantiate()
	nextScene.global_position = Vector2(0, viewportRect.size.y)
	add_child(nextScene)
	
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(nextScene, "global_position", Vector2(0, 0), 0.5)
	currentScene.queue_free()
	
	currentScene = nextScene
	_load_signals(currentScene)

func _load_signals(scene):
	for child in scene.find_children("*", "MenuButtonState", true):
		child.pressed.connect(_menu_button_pressed.bind(child))

func _unload_signals(scene):
	for child in scene.find_children("*", "MenuButtonState", true):
		child.pressed.disconnect(_menu_button_pressed.bind(child))
