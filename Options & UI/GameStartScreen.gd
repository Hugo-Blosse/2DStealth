extends Node2D

@onready var config = ConfigFile.new()
@onready var err = config.load_encrypted_pass("res://settings.cfg", "UngaBunga")

var fade_away_started : bool = false

const level1 = preload("res://main.tscn")
const labels_texts : Dictionary = {
					"Attack": " to Attack",
					"Dodge": " to Teleport",
					"Left": " and",
					"Right": " to Move",
					"Down": " to Drop",
					"Jump": " to Jump",
					"Shoot_Light": " to Light"
				}

func _ready():
	if !err:
		for control_setting in config.get_section_keys("settings_controls"):
			for label in get_tree().get_nodes_in_group("labels"):
				if label.name.to_lower() == control_setting && label.name in labels_texts:
					label.text = str(config.get_value("settings_controls", control_setting).as_text(), labels_texts[label.name])

func _input(event):
	if !event is InputEventMouseButton && !event is InputEventMouseMotion:
		fade_away_started = true

func _physics_process(_delta):
	if fade_away_started:
		$CanvasModulate.color.r -= 0.01
		$CanvasModulate.color.b -= 0.01
		$CanvasModulate.color.g -= 0.01
		if $CanvasModulate.color.r <= 0:
			get_tree().change_scene_to_packed(level1)
