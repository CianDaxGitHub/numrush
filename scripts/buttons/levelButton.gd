class_name LevelButton extends MenuButtonState

@export var label: Label
@export var lock: TextureRect
@export var levelList: Array[LevelInfo]

func _process(_delta: float) -> void:
	label.visible = false if self.disabled else true
	lock.visible = true if self.disabled else false
