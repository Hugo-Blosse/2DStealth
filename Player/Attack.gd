extends PlayerState


func enter():
	player.attack_hitbox.disabled = false
	%PlayerAttackSound.play()

func physics_update(_delta):
	player.velocity.x = 0
	emit_signal("animation_change", "attack")
	player.hit_enemy()
