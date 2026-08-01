extends Node

@export var initState: DialogState

var currentState: DialogState
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is DialogState:
			states[child.name.to_lower()] = child
			child.switched.connect(on_state_switch)
	
	if initState:
		initState.enter()
		currentState = initState

func _process(delta: float) -> void:
	if currentState:
		currentState.update(delta)

func on_state_switch(state, newStateName):
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.exit()
	
	newState.enter()
	currentState = newState
