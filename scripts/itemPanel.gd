extends Control

@onready var tex: Texture2D
@onready var itemFrame = %ItemFrame

func _ready() -> void:
	itemFrame.texture = tex
