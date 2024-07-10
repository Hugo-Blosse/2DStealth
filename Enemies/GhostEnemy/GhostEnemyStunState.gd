extends State

signal check()

func enter():
	character.velocity = Vector2.ZERO
	%StunAnimationTimer.start()
	character.animated_sprite.material.set("shader_parameter/stunned", !character.animated_sprite.material.get("shader_parameter/stunned"))
	%Hit.play()

func exit():
	character.rotation = 0
	emit_signal("check")
	%StunAnimationTimer.stop()
	character.animated_sprite.material.set("shader_parameter/stunned", false)

func _on_stun_animation_timer_timeout():
	character.animated_sprite.material.set("shader_parameter/stunned", !character.animated_sprite.material.get("shader_parameter/stunned"))
