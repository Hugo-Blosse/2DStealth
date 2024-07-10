extends Area2D

@export var barrier_timer_wait_time : int = 10

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

signal destroyed()
signal spotted()

func _ready():
	$BarrierTimer.wait_time = barrier_timer_wait_time
	player.hit.connect(_on_damage_taken)

func _on_barrier_timer_timeout():
	if $Barrier:
		$Barrier.queue_free()

func _on_damage_taken():
	for player_weapon in get_overlapping_areas():
		if $ProtectiveFire.visible && player_weapon.name == "Weapon":
			emit_signal("destroyed")
			$ProtectiveFire.visible = false

func _on_visible_on_screen_enabler_2d_screen_entered():
	emit_signal("spotted")
	if $BarrierTimer.is_stopped():
		$BarrierTimer.start()
