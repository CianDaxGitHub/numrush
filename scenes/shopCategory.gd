extends Control

@onready var items
@onready var itemSelected
var itemIndex = 0

var type: String
@onready var carousel = %ShopCarousel
@onready var txtType = %txtType
@onready var carMain =  %Main
@onready var txtItem = %txtItem
@onready var btnBuy = %btnBuy
@onready var txtPrice = %txtPrice

@onready var itemPanel = preload("res://scenes/itemPanel.tscn")

@onready var shop = $"../../../"
signal itemBuy(resSel)

func _ready() -> void:
	txtType.text = type
	
	_set_item()
	for i in items.size():
		var newPanel = itemPanel.instantiate()
		newPanel.tex = items[i].prevTex
		carMain.add_child(newPanel)

func _set_item():
	itemSelected = items[itemIndex]
	
	txtItem.text = itemSelected.displayName
	txtPrice.text = "%d" % itemSelected.price
	
	if !itemSelected.bought:
		btnBuy.disabled = false
		btnBuy.text = "Buy"
	else:
		btnBuy.disabled = true
		btnBuy.text = "SOLD"

func _on_btn_left_pressed() -> void:
	itemIndex = clampi(itemIndex - 1, 0, items.size() - 1)
	_set_item()
	carousel.left()


func _on_btn_right_pressed() -> void:
	itemIndex = clampi(itemIndex + 1, 0, items.size() - 1)
	_set_item()
	carousel.right()

func bought():
	btnBuy.disabled = true
	btnBuy.text = "SOLD"

func _on_btn_buy_pressed() -> void:
	itemBuy.connect(shop._on_item_buy)
	itemBuy.emit(itemSelected)
	itemBuy.disconnect(shop._on_item_buy)
