extends State

var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func enter():
	%WizardAnimation.play("Idle")
	$AttackTimer.wait_time = rng.randi_range(2, 10)
	$AttackTimer.start()

func _on_attack_timer_timeout():
	if state_machine.current_state.name != "WizardUnseen":
		emit_signal("transition", "WizardAttack")
