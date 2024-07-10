extends Control

@onready var config = ConfigFile.new()
@onready var err = config.load_encrypted_pass("res://settings.cfg", "UngaBunga")

var can_change_brightness : bool = true
var brightness : DirectionalLight2D
var action_name : String = ""
var label : Label = null

func _ready():
	if err != OK:
		config.set_value("settings", "resolution_height", "1920")
		config.set_value("settings", "resolution_width", "1080")
		config.set_value("settings", "window_mode", 0)
		config.set_value("settings", "brightness", 0)
		config.set_value("settings", "master_volume", 1)
		config.set_value("settings", "sfx_volume", 1)
		config.set_value("settings", "music_volume", 1)
		config.set_value("settings_controls", "left", BL.new())
		config.set_value("settings_controls", "right", BR.new())
		config.set_value("settings_controls", "down", BD.new())
		config.set_value("settings_controls", "jump", BJ.new())
		config.set_value("settings_controls", "attack", BA.new())
		config.set_value("settings_controls", "dodge", BDG.new())
		config.set_value("settings_controls", "shoot_light", BSL.new())
		config.save_encrypted_pass("res://settings.cfg", "UngaBunga")
		return
		
	DisplayServer.window_set_size(Vector2i(config.get_value("settings", "resolution_height").to_int(), config.get_value("settings", "resolution_width").to_int()))
	if config.get_value("settings", "resolution_height") == "1280":
		%ResolutionButton.selected = 0
	elif config.get_value("settings", "resolution_height") == "1920":
		%ResolutionButton.selected = 1
	else:
		%ResolutionButton.selected = 2
	if config.get_value("settings", "window_mode") == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	elif config.get_value("settings", "window_mode") == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	%OptionButton.selected = config.get_value("settings", "window_mode")

	for control_setting in config.get_section_keys("settings_controls"):
		InputMap.action_erase_events(control_setting)
		InputMap.action_add_event(control_setting, config.get_value("settings_controls", control_setting))
		for child in $TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer.get_children():
			if child.name.to_lower() == control_setting:
				for _label in child.get_children():
					if _label is Label && _label.name != "Label" && _label.text != config.get_value("settings_controls", control_setting).as_text():
						_label.text = config.get_value("settings_controls", control_setting).as_text()

	AudioServer.set_bus_volume_db(0, linear_to_db(config.get_value("settings", "master_volume")))
	%MasterVolumeSlider.value = config.get_value("settings", "master_volume")
	if config.get_value("settings", "master_volume") == %MasterVolumeSlider.min_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)

	AudioServer.set_bus_volume_db(1, linear_to_db(config.get_value("settings", "sfx_volume")))
	%SFXVolumeSlider.value = config.get_value("settings", "sfx_volume")
	if config.get_value("settings", "sfx_volume") == %SFXVolumeSlider.min_value:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)

	AudioServer.set_bus_volume_db(2, linear_to_db(config.get_value("settings", "music_volume")))
	%MusicVolumeSlider.value = config.get_value("settings", "music_volume")
	if config.get_value("settings", "music_volume") == %MusicVolumeSlider.min_value:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)

func _on_resolution_button_item_selected(index):
	var height : String = %ResolutionButton.get_item_text(index).erase(4, 7)
	var width : String = %ResolutionButton.get_item_text(index).erase(0, 7)
	DisplayServer.window_set_size(Vector2i(height.to_int(), width.to_int()))
	config.set_value("settings", "resolution_height", height)
	config.set_value("settings", "resolution_width", width)

func _on_option_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	config.set_value("settings", "window_mode", index)

func _on_brightness_slider_drag_ended(_value_changed):
	if can_change_brightness:
		brightness.set_energy(1 - %BrightnessSlider.value/100)
	config.set_value("settings", "brightness", (%BrightnessSlider.value/100))

func _on_brightness_slider_value_changed(value):
	%BrightnessPercentage.text = str(value, "%")

func _input(event):
	if $TabContainer/Controls.visible && event is InputEventMouseButton && event.button_index == 4:
		$TabContainer/Controls/MarginContainer/HBoxContainer/VSlider.value += 10
		
	if $TabContainer/Controls.visible && event is InputEventMouseButton && event.button_index == 5:
		$TabContainer/Controls/MarginContainer/HBoxContainer/VSlider.value -= 10
		
	if %PopUp.visible && !(event is InputEventMouseMotion):
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		config.set_value("settings_controls", action_name, event)
		for child in $TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer.get_children():
			for _label in child.get_children():
				if _label is Label && _label.text == event.as_text():
					_label.text = ""
					InputMap.action_erase_events(_label.get_parent().name.to_lower())
		label.text = event.as_text()
		%PopUp.visible = false

func _on_left_button_setting_pressed():
	$PopUp.visible = true
	action_name = "left"
	label = %LeftLabel

func _on_right_button_setting_pressed():
	$PopUp.visible = true
	action_name = "right"
	label = %RightLabel

func _on_down_button_setting_pressed():
	$PopUp.visible = true
	action_name = "down"
	label = %DownLabel

func _on_jump_button_setting_pressed():
	$PopUp.visible = true
	action_name = "jump"
	label = %JumpLabel

func _on_attack_button_setting_pressed():
	$PopUp.visible = true
	action_name = "attack"
	label = %AttackLabel

func _on_teleport_button_setting_pressed():
	$PopUp.visible = true
	action_name = "dodge"
	label = %TeleportLabel

func _on_shoot_button_setting_pressed():
	$PopUp.visible = true
	action_name = "shoot_light"
	label = %ShootLabel

func _on_v_slider_value_changed(value):
	if value > 66.6:
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Left.visible = true
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Dodge.visible = false
	elif value <= 66.6 && value > 33.3:
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Left.visible = false
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Right.visible = true
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Dodge.visible = true
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Shoot_Light.visible = false
	else:
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Right.visible = false
		$TabContainer/Controls/MarginContainer/HBoxContainer/VBoxContainer/Shoot_Light.visible = true

func _on_master_volume_slider_value_changed(value):
	%MasterVolume.text = str(int(100*value/%MasterVolumeSlider.max_value),"%")

func _on_master_volume_slider_drag_ended(_value_changed):
	AudioServer.set_bus_volume_db(0, linear_to_db(%MasterVolumeSlider.value))
	config.set_value("settings", "master_volume", %MasterVolumeSlider.value)
	if %MasterVolumeSlider.value == %MasterVolumeSlider.min_value:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)

func _on_sfx_volume_slider_value_changed(value):
	%SFXVolume.text = str(int(100*value/%SFXVolumeSlider.max_value),"%")

func _on_sfx_volume_slider_drag_ended(_value_changed):
	AudioServer.set_bus_volume_db(1, linear_to_db(%SFXVolumeSlider.value))
	config.set_value("settings", "sfx_volume", %SFXVolumeSlider.value)
	if %SFXVolumeSlider.value == %SFXVolumeSlider.min_value:
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)

func _on_music_volume_slider_value_changed(value):
	%MusicVolume.text = str(int(100*value/%MusicVolumeSlider.max_value),"%")

func _on_music_volume_slider_drag_ended(_value_changed):
	AudioServer.set_bus_volume_db(2, linear_to_db(%MusicVolumeSlider.value))
	config.set_value("settings", "music_volume", %MusicVolumeSlider.value)
	if %MusicVolumeSlider.value == %MusicVolumeSlider.min_value:
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)

func change_brightness():
	brightness.set_energy(1 - config.get_value("settings", "brightness"))
	%BrightnessSlider.value = config.get_value("settings", "brightness")*100
	%BrightnessPercentage.text = str(config.get_value("settings", "brightness")*100, "%")

func save():
	config.save_encrypted_pass("res://settings.cfg", "UngaBunga")
