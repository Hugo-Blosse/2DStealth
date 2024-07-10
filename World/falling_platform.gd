class_name FallingPlatform
extends AnimatedSprite2D

@onready var fall_timer = $FallTimer
@onready var rebuild_timer = $RebuildTimer
@onready var collision = $StaticBody2D/FallingPlatformCollision
@onready var player_detection_collision = $Area2D/CollisionShape2D

var player

func _ready():
	player = get_tree().get_first_node_in_group("player")
	collision.animated_sprite = self
	fall_timer.wait_time = (sprite_frames.get_frame_count("break")-1)/sprite_frames.get_animation_speed("break")

func _on_area_2d_body_entered(body):
	if body.name == player.name:
		fall_timer.start()
		play("break")

func _on_fall_timer_timeout():
	collision.disabled = true
	player_detection_collision.disabled = true
	rebuild_timer.start()

func _on_rebuild_timer_timeout():
	play("rebuild")

func _on_falling_platform_collision_enable():
	collision.disabled = false
	player_detection_collision.disabled = false
