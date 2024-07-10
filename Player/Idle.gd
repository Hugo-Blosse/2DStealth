extends PlayerState


func physics_update(_delta):
	emit_signal("animation_change", "idle")
	if !player.is_on_floor():
		emit_signal("transition", "Fall")
	if Input.get_axis("left", "right") != 0 || player.velocity.x != 0:
		emit_signal("transition", "Run")
