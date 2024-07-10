extends Control

func _ready():
	visible = false

func create_tip(tip_name : String):
	visible = true
	$ColorRect/MarginContainer/VBoxContainer3/VBoxContainer/Tip.text = tip_name

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_exit_button_pressed():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
