extends AnimatedSprite2D

signal player_detected(position : Vector2)

var player #= get_tree().get_first_node_in_group("player")

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _on_detection_body_entered(body):
	if body.name == player.name:
		emit_signal("player_detected", global_position)
