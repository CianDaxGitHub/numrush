extends Node

var users_data = {}
var save_path = "user://users_data.save"

func _ready():
	load_users_data()

func save_users_data():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_var(users_data)
		file.close()

func load_users_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			users_data = file.get_var()
			file.close()

func username_exists(username: String) -> bool:
	return users_data.has(username.to_lower())

func create_user(username: String, password: String, full_name: String, gender: String, age: int) -> bool:
	if username_exists(username):
		return false
	
	users_data[username.to_lower()] = {
		"username": username,
		"password": password.sha256_text(),
		"full_name": full_name,
		"gender": gender,
		"age": age
	}
	save_users_data()
	return true

func validate_login(username: String, password: String) -> bool:
	var user_key = username.to_lower()
	if not users_data.has(user_key):
		return false
	
	return users_data[user_key]["password"] == password.sha256_text()

func get_user_data(username: String) -> Dictionary:
	var user_key = username.to_lower()
	if users_data.has(user_key):
		return users_data[user_key]
	return {}
