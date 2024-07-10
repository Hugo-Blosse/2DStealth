class_name HorizontalPath
extends Path2D

var speed = 100

func _ready():
	$PathFollow2D/GhostEnemy.global_position = self.global_position

func _process(delta):
	if $PathFollow2D/GhostEnemy.state_machine.current_state.name == "GhostEnemyIdle":
		$PathFollow2D.progress += speed * delta
	else:
		$PathFollow2D/GhostEnemy.animated_sprite.flip_v = false
