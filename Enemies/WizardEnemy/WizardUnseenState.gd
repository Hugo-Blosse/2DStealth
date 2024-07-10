extends State


func _on_visible_on_screen_notifier_2d_screen_entered():
	emit_signal("transition", "WizardIdle")
