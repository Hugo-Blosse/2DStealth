extends State

func enter():
	%WalkingCharacterAnimation.stop()
	%WCDamageTakenTimer.start()
	%WCStunAnimationTimer.start()
	%WalkingEnemySprite.material.set("shader_parameter/stunned", true)
	%WalkingEnemyHit.play()
	character.char_speed = 0

func exit():
	%WalkingEnemySprite.material.set("shader_parameter/stunned", false)
	%WCStunAnimationTimer.stop()
	character.char_speed = character.max_speed

func _on_wc_stun_animation_timer_timeout():
	%WalkingEnemySprite.material.set("shader_parameter/stunned", !%WalkingEnemySprite.material.get("shader_parameter/stunned"))

func _on_wc_damage_taken_timer_timeout():
	emit_signal("transition", "WalkingCharacterWalk")
