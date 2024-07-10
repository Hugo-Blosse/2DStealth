extends "res://World/falling_platform.gd"

signal break_multiple()

func _on_area_2d_body_entered(body):
	if body.name == player.name:
		fall_timer.start()
		emit_signal("break_multiple")
		play("break")

func _on_break_multiple():
	fall_timer.start()
	play("break")
