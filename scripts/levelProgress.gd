class_name LevelProgress extends TaloLoadable

var level_progress = [0, 0, 0, 0, 0]
var coins = 0
var currentFit = ["def", "def", "def", "def"]

func _ready() -> void:
	super()

func register_fields() -> void:
	for i in range(level_progress.size()):
		register_field("%s" % (["add", "sub", "mul", "div", "mix"][i]), level_progress[i])

	for n in range(currentFit.size()):
		register_field("%s" % ["top", "hat", "bottom", "shoes"][n], currentFit[n])
	
	register_field("coins", coins)

func on_loaded(data: Dictionary) -> void:
	var type: Array[String] = ["add", "sub", "mul", "div", "mix"]
	
	var fit: Array[String] = ["top", "hat", "bottom", "shoes"]
	
	for i in range(type.size()):
		if !data.has("%s" % [type[i]]):
			pass
		else:
			level_progress[i] = data["%s" % [type[i]]]
	
	for n in range(currentFit.size()):
		currentFit[n] = data["%s" % fit[n]]
	
	coins = data["coins"]

func refresh_data():
	level_progress = [0, 0, 0, 0, 0]
	coins = 0
	currentFit = ["def", "def", "def", "def"]
