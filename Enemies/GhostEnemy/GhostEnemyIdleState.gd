extends State

func enter():
	character.velocity = Vector2.ZERO

func physics_update(_delta):
	emit_signal("animation_change", "default")
