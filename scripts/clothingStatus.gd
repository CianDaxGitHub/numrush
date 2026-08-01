class_name ClothingStatus extends TaloLoadable

var resList = []

var _path = "res://char/resources/"
var loader = ResourceLoader.list_directory(_path)

var status

func _ready() -> void:
	super()
	for i in loader.size():
		var curFile = loader[i]
		var file_path = _path + curFile
		if ResourceLoader.exists(file_path):
			ResourceLoader.load_threaded_request(file_path)

func _process(_delta: float) -> void:
	for i in loader.size():
		status = ResourceLoader.load_threaded_get_status(_path + loader[i])
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var res = ResourceLoader.load_threaded_get(_path + loader[i])
			resList.append(res)

func on_loaded(data: Dictionary) -> void:
	for i in range(resList.size()):
		if data.has("%s" % resList[i].itemName):
			resList[i].bought = data["%s" % resList[i].itemName]
		else:
			pass

func register_fields() -> void:
	for i in range(resList.size()):
		register_field("%s" % resList[i].itemName, resList[i].bought)

func refresh_data():
	for i in range(resList.size()):
		resList[i].bought = false
