extends CharacterBody2D
class_name Player

var light_projectile = preload("res://Player/light_projectile.tscn")

#await animated_sprite.animation_finished

@export var speed : float = 200.0
@export var jump_velocity : float = -250.0
@export var knockback_velocity_y : float = -20
@export var knockback_velocity_x : float = 30
@export var dodge_cooldown_time : float

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine = $PlayerStateMachine
@onready var attack_hitbox = $Weapon/PlayerAttackHitbox

signal life_changed(player_hearts, player_hearts_after)
signal state_change(state_name : String)
signal hit()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var death_screen : Control
var remote_transform : RemoteTransform2D
var camera : Camera2D
var progress : ProgressBar
var direction : Vector2 = Vector2.ZERO
var has_jumped : bool = false
var knockback_position : int = 1
var was_on_floor : bool = false
var jump_modifier : float = 1.0
var max_hearts : int = 3
var hearts : int = max_hearts
var dead : bool = false
var killer : String = ""
var death_causes : Dictionary = {
	"Fall" : "Try not to fall.",
	"Ghost" : "You cannot kill this enemy. It seems to be attacted to green light.",
	"GreenWizard" : "Try to get rid of his barrier. He cannot control everything for a long time.",
	"WalkingEnemy" : "You cannot kill this enemy. It seems to be deaf and shortsighted."
}

func _ready():
	$PlayerStateMachine/PlayerState.state_machine = $PlayerStateMachine
	%DodgeTimer.wait_time = animated_sprite.sprite_frames.get_frame_count("teleport_1")/animated_sprite.sprite_frames.get_animation_speed("teleport_1") + animated_sprite.sprite_frames.get_frame_count("teleport_2")/animated_sprite.sprite_frames.get_animation_speed("teleport_2") + dodge_cooldown_time
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.damage_player.connect(_take_damage)

func _physics_process(delta):
	gravity_physics(delta)
	if Input.is_action_just_pressed("down") && is_on_floor():
		position.y += 1
	was_on_floor = is_on_floor()
	move_and_slide()
	update_facing_direction()
	progress.value = (progress.max_value -  %LightProjectileTimer.time_left)
	if was_on_floor &&  !is_on_floor():
		%CoyoteTimer.start()

func update_facing_direction():
	if state_machine.current_state.name != "Dead" && state_machine.current_state.name != "Attack" && state_machine.current_state.name != "Dodge":
		direction.x = Input.get_axis("left","right")
		if direction.x > 0:
			animated_sprite.flip_h = false
			attack_hitbox.scale.x = 1
		elif direction.x < 0:
			animated_sprite.flip_h = true
			attack_hitbox.scale.x = -1

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "death2":
		dead = true
	if animated_sprite.animation == "death":
		show_death_screen()
	if animated_sprite.animation == "attack":
		attack_hitbox.disabled = true
		if !%BufferTimer.is_stopped():
			emit_signal("state_change", "Jump")
		else:
			emit_signal("state_change", "Idle")
	if animated_sprite.animation == "teleport_1":
		if !animated_sprite.flip_h:
			%AnimationPlayer.play("teleport_right_end")
			position.x += %TeleportRight.position.x
		if animated_sprite.flip_h:
			%AnimationPlayer.play("teleport_left_end")
			position.x += %TeleportLeft.position.x
		animated_sprite.play("teleport_2")
	elif animated_sprite.animation == "teleport_2":
		emit_signal("state_change", "Idle")


func _take_damage(damage, positionx, enemy_name):
	if %InvulnerabilityTimer.is_stopped() && %DodgeTimer.is_stopped() && state_machine.current_state.name != "Dead":
		%InvulnerabilityTimer.start()
		if hearts > 0:
			hearts -= damage
		emit_signal("life_changed", hearts + damage, hearts)
		if hearts <= 0:
			killer = enemy_name
			emit_signal("state_change", "Dead")
		else:
			emit_signal("state_change", "Damaged")
			%KnockbackTimer.start()
			if positionx > position.x:
				knockback_position = 1
			else:
				knockback_position = -1

func gravity_physics(delta):
	if !is_on_floor() && state_machine.current_state.name != "Dead" && state_machine.current_state.name != "Attack" && state_machine.current_state.name != "Dodge":
		velocity.y += gravity * delta
	if is_on_floor():
		has_jumped = false

func hit_enemy():
	emit_signal("hit")

func shoot():
		%LightProjectileTimer.start()
		var l = light_projectile.instantiate()
		if !animated_sprite.flip_h:
			l.direction = Vector2(1, 0)
		else:
			l.direction = Vector2(-1, 0)
		get_parent().add_child(l)
		l.global_position = self.global_position

func _on_animation_change(animation_name):
	animated_sprite.play(animation_name)

func show_death_screen():
	if killer in death_causes:
		death_screen.create_tip(death_causes[killer])

func end():
	print("XD")
	emit_signal("state_change", "End")
