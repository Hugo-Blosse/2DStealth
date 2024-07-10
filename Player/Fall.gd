extends PlayerState


func enter() -> void:
	emit_signal("animation_change", "fall")

func physics_update(_delta):
	player.velocity.x = Input.get_axis("left","right") * player.speed
	if player.is_on_floor():
		if !%BufferTimer.is_stopped():
			emit_signal("transition", "Jump")
		else:
			emit_signal("transition", "Idle")
	if player.global_position.y >= 200:
		player.killer = "Fall"
		emit_signal("transition", "Dead")
