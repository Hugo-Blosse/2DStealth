extends PlayerState

var dir : int
var pause_menu

func enter():
	player.shoot()
	emit_signal("animation_change", "idle")
	if !player.animated_sprite.flip_h:
		dir = 1
	else:
		dir = -1
	%ZoomOutTimer.start()

func exit():
	player.camera.zoom = Vector2(1, 1)
	player.remote_transform.position = Vector2(0, 0)
	pause_menu.scale = Vector2(1, 1)

func physics_update(delta):
	player.remote_transform.position += dir * Vector2(60 * delta, 0)
	player.camera.zoom -= Vector2(delta, delta) / 20
	pause_menu.scale = Vector2(1 / player.camera.zoom.x + 0.01, 1 / player.camera.zoom.y + 0.01)
	if Input.get_axis("left", "right") != 0:
		emit_signal("transition", "Run")


func _on_zoom_out_timer_timeout():
	emit_signal("transition", "Idle")
