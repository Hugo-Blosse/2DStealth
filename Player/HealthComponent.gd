extends Node
class_name HealthComponent

@export var wait_time : int

@onready var damage_taken_timer : Timer = $DamageTakenTimer

signal state_change(state_name)

func _damage_taken():
	if damage_taken_timer.is_stopped():
		damage_taken_timer.wait_time = wait_time
		damage_taken_timer.start()
		emit_signal("state_change", "GhostEnemyStun")


func _on_damage_taken_timer_timeout():
	emit_signal("state_change", "GhostEnemyBack")
