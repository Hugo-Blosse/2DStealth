extends State

signal check()

func enter():
	emit_signal("animation_change", "default")
	character.rotation = 0
	%GhostLight.scale = Vector2(3.45, 3.45)
	%GhostShadow.scale = Vector2(3.45, 3.45)
	character.detection_range.scale = Vector2(1,1)

func exit():
	emit_signal("check")

func physics_update(_delta):
	if (character.starting_position - character.position).length() < 4:
		character.velocity = Vector2.ZERO
		character.position = character.starting_position
		
	if (character.starting_position - character.position).length() > 20:
		character.velocity = (character.starting_position - character.position).normalized() * 400
	elif character.position != character.starting_position:
		character.velocity = (character.starting_position - character.position).normalized() * 100
	else:
		emit_signal("transition", "GhostEnemyIdle")
