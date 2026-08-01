extends Control

@onready var items = []
@onready var main = get_tree().current_scene

@onready var avatarBtn = preload("res://scenes/avatarBtn.tscn")
@onready var avatarCont = %avatarContainer
@onready var character = %Char

@onready var fit = get_tree().current_scene.get_node("levelProgress")
@onready var cloth = get_tree().current_scene.get_node("clothingStatus")

var category: int = 0

func get_category(button):
	$PolyAudio.play_sfx_from_lib("pop", randf_range(0.86, 0.92), -14)
	var btnPress = button.name
	
	match btnPress:
		"btnShirt":
			category = 0
		"btnLongSleeve":
			category = 1
		"btnJacket":
			category = 2
		"btnHat":
			category = 3
		"btnShorts":
			category = 4
		"btnSkirt":
			category = 5
		"btnPants":
			category = 6
		"btnShoes":
			category = 7
	clear_menu()
	build_menu()

func _ready() -> void:
	category = 0
	character.anim.play("avatar_start")
	var clothesStatus = cloth
	for i in range(clothesStatus.resList.size()):
		if clothesStatus.resList[i].bought == true:
			items.append(clothesStatus.resList[i])
	
	for child in %HBoxContainer.find_children("*", "SizableButton", true):
		child.pressed.connect(get_category.bind(child))
	
	build_menu()
	
	await character.anim.animation_finished
	character.anim.play("idle")

func clear_menu():
	for i in avatarCont.get_children():
		if i.get_index() == 0:
			i.setDefault.disconnect(_on_set_default)
		else:
			i.switchClothes.disconnect(_on_clothes_switch)
		i.queue_free()

func build_menu():
	var firstBtn = avatarBtn.instantiate()
	firstBtn.cat = category
	firstBtn.setDefault.connect(_on_set_default)
	avatarCont.add_child(firstBtn)
	for i in items.size():
		if items[i].category == category:
			var newBtn = avatarBtn.instantiate()
			newBtn.res = items[i]
			newBtn.cat = category
			newBtn.switchClothes.connect(_on_clothes_switch)
			avatarCont.add_child(newBtn)

func _on_clothes_switch(res: ClothingInfo):
	$PolyAudio.play_sfx_from_lib("pop", randf_range(0.96, 1.05), -14)
	match res.category:
		0, 1, 2:
			fit.currentFit[0] = res.itemName
		3:
			fit.currentFit[1] = res.itemName
		4, 5, 6:
			fit.currentFit[2] = res.itemName
		7:
			fit.currentFit[3] = res.itemName
	
	character.clothes_change(res)

func _on_set_default(cat: int):
	var index: int
	var curRes: ClothingInfo = null
	match cat:
		0, 1, 2:
			if fit.currentFit[0] != "def":
				index = cloth.loader.find(fit.currentFit[0] + ".tres")
				curRes = cloth.resList[index]
		3:
			if fit.currentFit[1] != "def":
				index = cloth.loader.find(fit.currentFit[1] + ".tres")
				curRes = cloth.resList[index]
		4, 5, 6:
			if fit.currentFit[2] != "def":
				index = cloth.loader.find(fit.currentFit[2] + ".tres")
				curRes = cloth.resList[index]
		7:
			if fit.currentFit[3] != "def":
				index = cloth.loader.find(fit.currentFit[3] + ".tres")
				curRes = cloth.resList[index]
	if curRes != null:
		if category != curRes.category:
			$PolyAudio.play_sfx_from_lib("misstep", randf_range(0.96, 1.05), -18)
			return
		else:
			$PolyAudio.play_sfx_from_lib("pop", randf_range(0.96, 1.05), -14)
	else:
		$PolyAudio.play_sfx_from_lib("misstep", randf_range(0.96, 1.05), -18)
	
	match cat:
		0, 1, 2:
			fit.currentFit[0] = "def"
		3:
			fit.currentFit[1] = "def"
		4, 5, 6:
			fit.currentFit[2] = "def"
		7:
			fit.currentFit[3] = "def"
	
	character.set_default(cat)

func _on_btn_home_pressed() -> void:
	main.game_save()

func _on_btn_shop_pressed() -> void:
	main.game_save()
