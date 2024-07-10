extends PlayerState


func enter() -> void:
	emit_signal("animation_change", "jump_start")
	player.has_jumped = true
	player.velocity.y = player.jump_velocity * player.jump_modifier
	%PlayerJumpSound.play()

func physics_update(_delta):
	player.velocity.x = Input.get_axis("left","right") * player.speed
	if player.is_on_floor():
		emit_signal("transition", "Idle")
	if player.velocity.y >= 0 && !player.is_on_floor():
		emit_signal("transition", "Fall")
