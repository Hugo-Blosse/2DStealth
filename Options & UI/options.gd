class_name OptionsMenu
extends Control

func _on_button_pressed() -> void:
	$MarginContainer/VBoxContainer/SettingsTab.save()
	visible = false
