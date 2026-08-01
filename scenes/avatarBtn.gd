extends Control

@onready var res: ClothingInfo
@onready var cat: int
@onready var behind: TextureRect = %behind
@onready var preview: TextureRect = %clothing

signal switchClothes(resource)
signal setDefault(category)

var icons = [
	"res://images/icons/clothes/men-t-shirts-icon.png",
	"res://images/icons/clothes/mens-shirts-half-sleeve-icon.png",
	"res://images/icons/clothes/hoodie-jacket-icon.png",
	"res://images/icons/clothes/cap-outline-icon.png",
	"res://images/icons/clothes/shorts-icon.png",
	"res://images/icons/clothes/girl-skirt-icon.png",
	"res://images/icons/clothes/jeans-pants-icon.png",
	"res://images/icons/clothes/boot-icon.png"
]

func _ready() -> void:
	if res == null:
		behind.visible = true
		behind.texture = load(icons[cat])
		preview.texture = load("res://images/icons/ban-sign-icon.png")
	else:
		behind.visible = false
		preview.texture = res.prevTex


func _on_avatar_btn_pressed() -> void:
	if res == null:
		setDefault.emit(cat)
	else:
		switchClothes.emit(res)
