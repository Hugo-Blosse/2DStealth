extends PlayerState


func _ready():
	pass

func Enter() -> void:
	pass

func Exit() -> void:
	pass

func Update(delta: float) -> void:
	pass

func Physics_Update(delta):
	if !player.knockback_timer.is_stopped():
		player.velocity.y = player.knockback_velocity_y
		player.velocity.x = player.knockback_velocity_y * player.knockback_position
	else:
		player.velocity = Vector2.ZERO
		emit_signal("transition", "Idle")
