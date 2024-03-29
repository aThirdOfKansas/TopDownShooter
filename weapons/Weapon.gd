extends Node2D
class_name Weapon

@export var Bullet: PackedScene

var team: int = -1

@onready var end_of_gun: Node = $EndOfGun
@onready var gun_direction: Node = $GunDirection
@onready var attack_cooldown: Node = $AttackCooldown
@onready var animation_player: Node = $AnimationPlayer


func initialize(init_team: int):
	self.team = init_team


func shoot():
	if attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = Bullet.instantiate()
		var direction = (gun_direction.global_position - end_of_gun.global_position).normalized()
		GlobalSignals.emit_signal("bullet_fired", bullet_instance, team, end_of_gun.global_position, direction)
		attack_cooldown.start()
		animation_player.play("muzzle_flash")
	else:
		pass
