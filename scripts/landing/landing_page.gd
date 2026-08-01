extends Control


signal switchScene(page)

@onready var create_account_button = %btnCreate
@onready var sign_in_button = %btnLogin

func _ready():
	create_account_button.pressed.connect(_on_create_account_pressed)
	sign_in_button.pressed.connect(_on_sign_in_pressed)

func _on_create_account_pressed():
	switchScene.emit("signup")

func _on_sign_in_pressed():
	switchScene.emit("signin")
