extends PlayerState


func enter() -> void:
	%DeathSound.play()
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(1, false)
	if player.is_on_floor():
		emit_signal("animation_change", "death")
		%DeathTeleport.visible = false
	else:
		emit_signal("animation_change", "death2")
		player.emit_signal("life_changed", player.hearts, 0)
		%AnimationPlayer.clear_queue()
		%AnimationPlayer.play("death")

func physics_update(delta):
	player.velocity = Vector2.ZERO
	if player.dead:
		player.rotation += delta
		player.scale -= Vector2(delta, delta) / 2
		%DeathTeleport.rotation -= delta
		%DeathTeleport.scale = Vector2(1 / player.scale.x, 1 / player.scale.y) 
		if player.scale <= Vector2(delta, delta):
			player.visible = false
			player.show_death_screen()
