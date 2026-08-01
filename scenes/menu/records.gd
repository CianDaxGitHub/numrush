extends Control

var _path = "user://history.save"
var resultList = []
var qtnList = []

@onready var recordHolder = %recordHolder
@onready var recordPanel = preload("res://scenes/recordPanel.tscn")
@onready var warning = %warning
@onready var userLabel: Label = $Sign/userLabel

func _ready() -> void:
	userLabel.text = "%s's\nGame History" % Talo.current_alias.identifier
	_get_record_data()
	await get_tree().create_timer(0.6).timeout
	resultList.reverse()
	qtnList.reverse()
	
	for i in range(resultList.size()):
		var newPanel = recordPanel.instantiate()
		newPanel.type = resultList[i][0]
		newPanel.estTime = resultList[i][1]
		newPanel.correct = resultList[i][2]
		newPanel.lvl = resultList[i][3]
		newPanel.coins = resultList[i][4]
		newPanel.success = resultList[i][5]
		newPanel.target = resultList[i][6]
		newPanel.questions = qtnList[i]
		
		recordHolder.add_child(newPanel)
		await get_tree().create_timer(0.1).timeout

func _get_record_data():
	var file = FileAccess.open(_path, FileAccess.READ)
	if file != null:
		warning.visible = false
		resultList = file.get_var()
		qtnList = file.get_var()
	else:
		warning.visible = true
