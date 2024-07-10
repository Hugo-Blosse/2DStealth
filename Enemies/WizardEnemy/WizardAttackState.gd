extends State

func enter():
	%WizardAnimation.play("Attack")

func exit():
	character.shoot()

func physics_update(_delta):
	if !%WizardAnimation.is_playing():
		emit_signal("transition", "WizardIdle")
