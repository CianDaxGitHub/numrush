class_name SizableButton
extends Button
@export var scaleSize: float

@export var sfx: AudioStreamPlayer

@export var sfx_name: Array[String]
@export var sfx_vol: Array[float]
@export var sfx_delay: Array[float]

func button_down() -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2.ONE * scaleSize, 0.1)

func button_up() -> void:
	var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2.ONE * 0.97, 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
	if sfx:
		sfx.play_sfx_from_lib(sfx_name[0], 1, sfx_vol[0], sfx_delay[0])

func _button_pressed():
	if sfx and sfx_name.size() > 1:
		sfx.play_sfx_from_lib(sfx_name[1], 1, sfx_vol[1], sfx_delay[1])
