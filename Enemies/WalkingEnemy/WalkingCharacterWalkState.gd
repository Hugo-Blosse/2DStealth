extends State


func exit():
	character.max_speed = character.char_speed

func physics_update(_delta):
	%WalkingCharacterAnimation.play("Walk")
	for body in %Detection.get_overlapping_bodies():
		if body.name == character.player.name:
			emit_signal("transition", "WalkingCharacterAttack")
