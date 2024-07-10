extends CollisionShape2D

var animated_sprite

signal enable()

func _on_falling_platform_animation_finished():
	if animated_sprite.animation == "rebuild":
		emit_signal("enable")
