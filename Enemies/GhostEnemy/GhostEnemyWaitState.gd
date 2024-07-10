extends State

func enter():
	character.velocity = Vector2.ZERO

func physics_update(_delta):
	emit_signal("animation_change", "default")

func _on_light_check_timer_timeout():
	if state_machine.current_state.name != "GhostEnemyStun":
		emit_signal("transition",  "GhostEnemyBack")
