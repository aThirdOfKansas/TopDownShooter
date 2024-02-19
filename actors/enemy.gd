extends CharacterBody2D

@export var speed: int = 100

@onready var health_stat: Node = $Health
@onready var ai = $AI
@onready var weapon = $Weapon


func _ready() -> void:
	ai.initialize(self, weapon)


func _physics_process(_delta):
	pass

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()


func velocity_toward(location: Vector2) -> Vector2:
	return global_position.direction_to(location) * speed


func rotate_toward(location: Vector2):
	rotation = lerp(rotation, global_position.direction_to(location).angle(), 0.1)
