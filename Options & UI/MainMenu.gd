extends Node2D

const level1 = preload("res://Options & UI/game_start_screen.tscn")

func _ready():
	%MenuAnimation.play("start")
	$MarginContainer/CanvasLayer2/OptionsMenu/MarginContainer/VBoxContainer/SettingsTab.can_change_brightness = false

func start_game():
	get_tree().change_scene_to_packed(level1)
	$MarginContainer/CanvasLayer2/OptionsMenu/MarginContainer/VBoxContainer/SettingsTab.can_change_brightness = true

func _on_options_button_pressed():
	$MarginContainer/CanvasLayer2/OptionsMenu.visible = true

func _quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _physics_process(delta):
	$MarginContainer/Player/Sprite2D.rotation += delta
	if !%MenuMusic.playing:
		%MenuMusic.play()
