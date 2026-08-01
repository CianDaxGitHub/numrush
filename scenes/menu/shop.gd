extends Control

@onready var shopCat = preload("res://scenes/shopCategory.tscn")

@onready var main = $"../../levelProgress"
@onready var clothes = $"../../clothingStatus"
@onready var coinLabel = %coinLabel

@onready var scroll = %VBoxContainer
@onready var categories = [[], [], [], [], [], [], [], []]

@onready var popupScene = [preload("res://scenes/NoCoinsPopup.tscn"), preload("res://scenes/BuyPopup.tscn")]
@onready var anim = $AnimationPlayer
func _ready() -> void:
	coinLabel.text = "%d" % main.coins
	for item in clothes.resList.size():
		categories[clothes.resList[item].category].append(clothes.resList[item])
	
	for category in categories.size():
		var newCat = shopCat.instantiate()
		newCat.type = "%s" % ["Shirts", "Sleeved", "Jackets", "Hats", "Shorts", "Skirts", "Pants", "Shoes"][category]
		newCat.items = categories[category]
		scroll.add_child(newCat)
		await get_tree().create_timer(0.15).timeout

func get_coins(value):
	var displayed_value = value
	coinLabel.text = str(displayed_value)

func update_shop(res):
	var tween = self.create_tween()
	$PolyAudio.play_sfx_from_lib("bought")
	anim.play("coin_flash")
	tween.tween_method(Callable(self, "get_coins"), main.coins + res.price, main.coins, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	coinLabel.text = "%d" % main.coins
	scroll.get_child((res.category + 1)).bought()

func _on_item_buy(res):
	var popup
	if main.coins < res.price:
		popup = popupScene[0].instantiate()
		self.add_child(popup)
	else:
		popup = popupScene[1].instantiate()
		popup.res = res
		self.add_child(popup)
