class_name PlayerState
extends Node

@onready var player = get_parent().get_parent()

signal transition(new_state_name: StringName)
signal animation_change(animation_name : String)

var state_machine

func enter() -> void:
	pass

func exit() -> void:
	pass

func _input(_event):
	if state_machine.current_state.name == "End":
		return
	if (state_machine.current_state.name == "Run" || state_machine.current_state.name == "Idle" || state_machine.current_state.name == "LightProjectile") && state_machine.current_state.name != "Dodge":
		if Input.is_action_just_pressed("jump"):
			emit_signal("transition", "Jump")
		if Input.is_action_just_pressed("attack"):
			emit_signal("transition", "Attack")
	if state_machine.current_state.name == "Fall" || state_machine.current_state.name == "Attack":
		if Input.is_action_just_pressed("jump"):
			if !%CoyoteTimer.is_stopped() && !player.has_jumped:
				emit_signal("transition", "Jump")
			else:
				%BufferTimer.start()
	if state_machine.current_state.name != "Attack" && state_machine.current_state.name != "Dead":
		if Input.is_action_just_pressed("shoot_light") && %LightProjectileTimer.is_stopped() && state_machine.current_state.name != "Dodge":
			emit_signal("transition", "LightProjectile")
		if Input.is_action_just_pressed("dodge") && %DodgeTimer.is_stopped():
			if !player.animated_sprite.flip_h:
				if !%TeleportRight.has_overlapping_bodies():
					player.animated_sprite.play("teleport_1")
					%AnimationPlayer.play("teleport_right_start")
					%AnimationPlayer.queue("teleport_right_end")
					emit_signal("transition", "Dodge")
				else:
					emit_signal("transition", "Idle")
			if player.animated_sprite.flip_h:
				if !%TeleportLeft.has_overlapping_bodies():
					player.animated_sprite.play("teleport_1")
					%AnimationPlayer.play("teleport_left_start")
					%AnimationPlayer.queue("teleport_left_end")
					emit_signal("transition", "Dodge")
				else:
					emit_signal("transition", "Idle")

func physics_update(_delta):
	pass
