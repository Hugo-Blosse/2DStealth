extends PlayerState


func enter() -> void:
	%DodgeTimer.start()
	%TeleportSound.play()

func physics_update(_delta):
	player.velocity = Vector2.ZERO
