extends Node2D

const credits = preload("res://credits.tscn")

func _ready():
	$Player.remote_transform = $Player/RemoteTransform2D
	$Player.camera = $Camera2D
	$Player.progress = $UI/ProgressBar
	$Player.death_screen = $UI/DeathScreen
	$Enemies/GreenWizardEnemy.scene = self
	$Camera2D/PauseMenu.sound = %SelectSound
	$UI/ProgressBar.max_value = $Player/LightProjectileTimer.wait_time
	$Camera2D/PauseMenu/CanvasLayer/OptionsMenu/MarginContainer/VBoxContainer/SettingsTab.brightness = $Camera2D/DirectionalLight2D
	await $Camera2D/PauseMenu/CanvasLayer/OptionsMenu/MarginContainer/VBoxContainer/SettingsTab.change_brightness()
	$Player/PlayerStateMachine/LightProjectile.pause_menu = $Camera2D/PauseMenu
	$Camera2D/PauseMenu/MarginContainer/VBoxContainer/PHBoxContainer/PauseButton.pressed.connect(_pause)
	$Camera2D/PauseMenu/MarginContainer/VBoxContainer/EHBoxContainer/ExitButton.pressed.connect(_quit)

func _input(_event):
	if Input.is_action_just_pressed("pause") && !$Camera2D/PauseMenu/CanvasLayer/OptionsMenu.visible:
		_pause()

func _pause():
	get_tree().paused = !get_tree().paused
	%SelectSound.play()
	$Camera2D/PauseMenu.visible = !$Camera2D/PauseMenu.visible

func _quit():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func _process(_delta):
	if !%Music.playing:
		%Music.play()

func end():
	get_tree().change_scene_to_packed(credits)
