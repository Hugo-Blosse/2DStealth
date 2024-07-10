extends PlayerState


func physics_update(delta):
	player.camera.zoom += 2*Vector2(delta, delta)
