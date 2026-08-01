extends Control

var to_load = []

var loaded = []
var allLoaded = false

@onready var loadingText = %loadingText

signal onLoaded

@onready var prog = %ProgressBar

func _ready() -> void:
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("loop")

func _process(_delta: float) -> void:
	var tween = prog.create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(prog, "value", (float(loaded.size()) / float(to_load.size())) * 100.0, 0.3)
	
	if loaded.size() == to_load.size() and allLoaded == false:
		var mainScene = get_tree().current_scene
		onLoaded.connect(mainScene._on_loaded)
		onLoaded.emit()
		onLoaded.disconnect(mainScene._on_loaded)
		allLoaded = true
