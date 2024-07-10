extends Area2D

@export var speed : int = 150
var direction : Vector2

func _ready():
	%LightProjectileAudio.play()

func _physics_process(delta):
	global_position += speed * delta * direction

func _on_visible_on_screen_notifier_2d_screen_exited():
	$OffScreenTimer.start()

func _on_off_screen_timer_timeout():
	queue_free()
