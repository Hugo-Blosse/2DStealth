extends CharacterBody2D

@export var velocity_component : VelocityComponent

@onready var player : Player = get_tree().get_first_node_in_group("player")

const enemy_name = "GreenWizard"

signal on_player_hit(positionx)

func _ready():
	velocity = (global_position.direction_to(player.global_position) * velocity_component.speed) + player.velocity
	rotation = global_position.direction_to(player.global_position).angle() - PI/2

func _delete():
	queue_free()

func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	$ProjectileAnimation.play("move")
	if collision:
		if collision.get_collider() == player:
			player._take_damage(1, position.x, enemy_name)
		queue_free()
