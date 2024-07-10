extends State

var new_position : Vector2
var light_check_timer : Timer
var turned : bool

func enter():
	if character.global_position.direction_to(new_position).x >= 0 && character.animated_sprite.flip_h:
		character.animated_sprite.flip_h = false
		turned = true
	if character.global_position.direction_to(new_position).x <= 0 && character.animated_sprite.flip_h:
		character.animated_sprite.flip_h = true
		turned = true

func exit():
	if turned:
		character.animated_sprite.flip_h = !character.animated_sprite.flip_h

func physics_update(_delta):
	character.velocity = character.global_position.direction_to(new_position) * character.velocity_component.speed
	if (character.global_position - new_position).length() <= 4:
		emit_signal("transition", "GhostEnemyWait")
		light_check_timer.start()

func _on_ghost_enemy_move_to_position(position):
	new_position = position
