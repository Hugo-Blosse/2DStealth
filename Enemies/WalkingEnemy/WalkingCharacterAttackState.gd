extends State

func enter():
	%WalkingCharacterAnimation.stop()
	%WalkingCharacterAnimation.play("Attack")
	character.char_speed = 0

func exit():
	%AttackHitbox.disabled = true
	character.char_speed = character.max_speed

func physics_update(_delta):
	for body in %Attack.get_overlapping_bodies():
		if body.name == character.player.name:
			character.emit_signal("damage_player", 1, character.global_position.x, character.enemy_name)
