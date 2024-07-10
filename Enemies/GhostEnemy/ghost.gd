extends CharacterBody2D

@export var damage : int = 2
@export var velocity_component : VelocityComponent
@export var sprite_flip_h : bool = true

@onready var hitbox : Area2D = $Hitbox
@onready var attack_hitbox : Area2D = $Attack_Hitbox
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite : AnimatedSprite2D = $GhostAnimatedSprite2D
@onready var detection : Area2D = $Detection
@onready var detection_range : CollisionShape2D = $Detection/CollisionShape2D
@onready var state_machine = $StateMachine
@onready var stun_timer = $HealthComponent/DamageTakenTimer

var target = null
var starting_position : Vector2
var detected_on_return : bool = false

const enemy_name : String = "Ghost"

signal damage_player(damage, positionx)
signal damage_taken()
signal state_change(state_name)
signal move_to_position(position)

func _ready():
	starting_position = position
	animated_sprite.flip_h = sprite_flip_h
	$StateMachine/GhostEnemyMove.light_check_timer = $LightCheckTimer
	player.hit.connect(_on_player_hit)

func turn(a,b,c):
	global_rotation = lerp_angle(a,b,c)

func _on_attack_hitbox_body_entered(body):
	if body.name == player.name:
		emit_signal("damage_player", damage, position.x, enemy_name)

func _on_detection_body_entered(body):
	if body.name == player.name && (state_machine.current_state.name != "GhostEnemyBack" && state_machine.current_state.name != "GhostEnemyStun" && player.state_machine.current_state.name != "End"):
		stun_timer.stop()
		detection_range.scale = Vector2(1.25,1.25)
		target = player
		emit_signal("state_change", "GhostEnemyAttackStart")

func _on_detection_body_exited(body):
	if body.name == player.name && (state_machine.current_state.name != "GhostEnemyBack" && state_machine.current_state.name != "GhostEnemyStun"):
		target = null
		emit_signal("state_change", "GhostEnemyBack")

func _physics_process(_delta):
	if detected_on_return:
		emit_signal("state_change", "GhostEnemyAttackStart")
	for body in attack_hitbox.get_overlapping_bodies():
		if body.name == player.name:
			emit_signal("damage_player", damage, position.x, enemy_name)
	move_and_slide()

func animation_change(animation_name):
	animated_sprite.play(animation_name)

func _on_player_hit():
	for player_weapon in hitbox.get_overlapping_areas():
		if player_weapon.name == "Weapon":
			emit_signal("damage_taken")

func _on_animation_finished():
	if animated_sprite.animation == "attack":
		emit_signal("state_change", "GhostEnemyAttack")

func _on_ghost_enemy_back_check():
	for body in detection.get_overlapping_bodies():
		if body.name == player.name:
			detected_on_return = true
			target = player

func _on_green_fire_player_detected(fire_position):
	if state_machine.current_state.name == "GhostEnemyIdle":
		emit_signal("move_to_position", fire_position)
		emit_signal("state_change", "GhostEnemyMove")
