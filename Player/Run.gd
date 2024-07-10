extends PlayerState


func physics_update(_delta):
	player.velocity.x = Input.get_axis("left","right") * player.speed
	emit_signal("animation_change", "run")
	if !player.is_on_floor():
		emit_signal("transition", "Fall")
	if player.velocity.x == 0:
		emit_signal("transition", "Idle")
