class_name WalkingEnemy
extends CharacterBody2D

@export var char_speed : float = 100.

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")

signal state_change(state_name : StringName)
signal damage_player(damage, positionx)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction : int = -1
var max_speed : float

const enemy_name = "WalkingEnemy"

func _ready():
	%AttackHitbox.disabled = true
	player.hit.connect(_on_player_hit)

func _physics_process(delta):
	if !%FloorDetection.is_colliding() || %WallDetection.is_colliding():
		%Position.scale.x = -%Position.scale.x
		direction = -direction
	velocity.y += gravity * delta
	velocity.x = char_speed * direction
	move_and_slide()

func _on_detection_body_entered(body):
	if body.name == player.name:
		emit_signal("state_change", "WalkingCharacterAttack")

func _on_walking_character_animation_animation_finished(anim_name):
	if anim_name == "Attack":
		emit_signal("state_change", "WalkingCharacterWalk")

func _on_player_hit():
	for player_weapon in %WCHitbox.get_overlapping_areas():
		if player_weapon.name == "Weapon":
			emit_signal("state_change", "WalkingCharacterStun")
