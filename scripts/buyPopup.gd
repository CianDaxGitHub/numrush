extends Control

@onready var res
@onready var popupText = %popupText

signal confirm(resource)

@onready var shop = $"../"

func _ready() -> void:
	popupText.text = popupText.text.replace("{no}", str(res.price))


func _on_btn_yes_pressed() -> void:
	confirm.connect(get_tree().current_scene._on_item_bought)
	confirm.connect(shop.update_shop)
	confirm.emit(res)
	confirm.disconnect(get_tree().current_scene._on_item_bought)
	confirm.disconnect(shop.update_shop)
	queue_free()

func _on_btn_no_pressed() -> void:
	$AnimationPlayer.play("exit_scene")
