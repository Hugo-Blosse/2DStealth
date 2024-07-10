extends Control

var sound : AudioStreamPlayer

func _on_options_button_pressed():
	sound.play()
	%OptionsMenu.visible = true
