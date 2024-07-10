extends State

func physics_update(_delta):
	character.velocity = character.global_position.direction_to(character.target.global_position) * character.velocity_component.speed
	character.rotation = character.global_position.direction_to(character.target.global_position).angle() + PI/2
