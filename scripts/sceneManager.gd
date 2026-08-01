extends Node

@onready var menu = preload("res://scenes/menuManager.tscn")


func _ready() -> void:
	var new_menu = menu.instantiate()
	self.add_child(new_menu)
