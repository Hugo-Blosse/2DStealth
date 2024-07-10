class_name State
extends Node

@onready var character = get_parent().get_parent()

signal transition(new_state_name: StringName)
signal animation_change(animation_name : String)

var state_machine = get_parent()

func enter() -> void:
	pass

func exit() -> void:
	pass

func physics_update(_delta):
	pass
