extends Control


@onready var boardContainer = %boardContainer
@onready var boardEntry = preload("res://scenes/boardEntry.tscn")

@onready var type = %type
@onready var warning: Label = %warning

var typeInd: int = 0

var typeTxt: String = "add"

var lvl: int = 1

func _ready():
	%lvlLabel.text = "Level %d" % lvl
	for i in type.find_children("*", "SizableButton", true):
		i.pressed.connect(get_type.bind(i))
	
	await _load_entries()

func get_type(button):
	var typePress = button.name
	
	for i in type.find_children("*", "SizableButton", true):
		i.self_modulate = Color(1.0, 1.0, 1.0)
	
	button.self_modulate = Color(1.825, 1.825, 1.825)
	
	match typePress:
		"Add":
			typeInd = 0
		"Sub":
			typeInd = 1
		"Mul":
			typeInd = 2
		"Div":
			typeInd = 3
		"Mix":
			typeInd = 4
	
	typeTxt = "%s" % ["add", "sub", "mul", "div", "mix"][typeInd]
	
	await _load_entries()

func _create_entry(entry: TaloLeaderboardEntry) -> void:
	var entryScene = boardEntry.instantiate()
	entryScene.entry = entry
	boardContainer.add_child(entryScene)

func _build_entries() -> void:
	var entries = Talo.leaderboards.get_cached_entries("%s" % typeTxt)
	
	entries = entries.filter(func (entry: TaloLeaderboardEntry): return entry.get_prop("level", "") == ("%d" % lvl))
	
	if entries.size() == 0:
		warning.visible = true
	else:
		warning.visible = false
	
	for entry in entries:
		entry.position = entries.find(entry)
		_create_entry(entry)
		await get_tree().create_timer(0.1).timeout
	
	for i in type.find_children("*", "SizableButton", true):
		i.disabled = false
	
	type.get_child(typeInd).get_child(0).disabled = true
	
	%left.disabled = false
	%right.disabled = false

func _load_entries() -> void:
	var scroll = %ScrollContainer
	for i in type.find_children("*", "SizableButton", true):
		i.disabled = true
	
	
	%left.disabled = true
	%right.disabled = true
	warning.visible = false
	
	for child in boardContainer.get_children():
		child.anim.play("exit_scene")
	
	if await Talo.is_offline():
		warning.visible = true
		for i in type.find_children("*", "SizableButton", true):
			i.disabled = false
		
		
		type.get_child(typeInd).get_child(0).disabled = true
		return
	
	scroll.scroll_vertical = 0
	
	var page := 0
	var done := false

	while !done:
		var options := Talo.leaderboards.GetEntriesOptions.new()
		options.page = page

		var res := await Talo.leaderboards.get_entries("%s" % typeTxt, options)

		var _entries := res.entries
		var is_last_page := res.is_last_page

		if is_last_page:
			done = true
		else:
			page += 1
	
	_build_entries()

func _on_btn_help_pressed() -> void:
	$AnimationPlayer.play("help_enter")

func _on_btn_back_pressed() -> void:
	$AnimationPlayer.play("help_exit")

func _on_left_pressed() -> void:
	lvl = wrapi(lvl-1, 1, 11)
	%lvlLabel.text = "Level %d" % lvl
	await _load_entries()

func _on_right_pressed() -> void:
	lvl = wrapi(lvl+1, 1, 11)
	%lvlLabel.text = "Level %d" % lvl
	await _load_entries()
