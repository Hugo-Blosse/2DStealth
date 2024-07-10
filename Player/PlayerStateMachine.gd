extends Node

@export var current_state : PlayerState

var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is PlayerState:
			child.state_machine = self
			states[child.name] = child
	current_state.enter()

func on_child_transitioned(new_state_name: StringName) -> void:
	var new_state = states.get(new_state_name)
	if new_state != null && new_state != current_state:
		current_state.exit()
		new_state.enter()
		current_state = new_state

func _physics_process(delta):
	current_state.physics_update(delta)
