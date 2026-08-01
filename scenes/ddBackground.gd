extends PanelContainer

@onready var main = $"../"

var type
var lvl
@onready var title = %titleLabel

func _ready() -> void:
	type = main.opType
	lvl = main.lvl
	
	title.text = "%s CHALLENGE #%d" % [["ADDITION", "SUBTRACTION", "MULTIPLICATION", "DIVISION", "MIXED"][type], lvl]
