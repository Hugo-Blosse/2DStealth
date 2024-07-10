extends CharacterBody2D

@export var health : int = 3

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

var scene

signal state_change(state_name : StringName)
signal damage_player(damage, positionx)

var projectile = preload("res://Enemies/WizardEnemy/projectile.tscn")

func _ready():
	player.hit.connect(_on_player_hit)
	$Head.visible = false
	$CPUParticles2D.emitting = false
	get_tree().get_first_node_in_group("barriers").destroyed.connect(_on_barrier_damaged)
	
func _on_player_hit():
	for player_weapon in %WEHitbox.get_overlapping_areas():
		if player_weapon.name == "Weapon":
			emit_signal("state_change", "WizardUnseen")
			player.end()
			%WizardAnimation.play("death")

func _on_barrier_damaged():
	health -= 1
	if health <= 0:
		%Barrier.queue_free()

func shoot():
		var p = projectile.instantiate()
		p.global_position = self.global_position + Vector2(-14, -20)
		scene.add_child(p)

func _on_fire_barrier_spotted():
	if %WizardAnimation.current_animation != "death":
		emit_signal("state_change", "WizardIdle")

func _on_wizard_animation_animation_finished(anim_name):
	if anim_name == "death":
		scene.end()
