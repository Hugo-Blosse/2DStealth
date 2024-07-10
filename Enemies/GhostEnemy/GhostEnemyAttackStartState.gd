extends State

func enter():
	emit_signal("animation_change", "attack")
	character.detected_on_return = false
	character.velocity = Vector2.ZERO
	%AttackStart.play()

func exit():
	%AttackStart.stop()

func physics_update(delta):
	character.turn(character.global_rotation, (character.target.global_position - character.global_position).angle() + PI/2, (character.animated_sprite.sprite_frames.get_frame_count("attack")/(character.animated_sprite.sprite_frames.get_animation_speed("attack"))))
	%GhostLight.scale += Vector2(delta, delta)
	%GhostShadow.scale += Vector2(delta, delta)
