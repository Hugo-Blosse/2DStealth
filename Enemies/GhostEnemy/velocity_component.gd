extends Node
class_name VelocityComponent

@export var speed : float
@export var speed_multiplier : float
@export var jump_speed : float
@export var max_speed : float

func move_area(area : Area2D):
	area.position.x += speed * speed_multiplier

func move(_character : CharacterBody2D):
	pass
