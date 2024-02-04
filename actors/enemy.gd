extends CharacterBody2D

@onready var health_stat: Node = $Health

func _physics_process(_delta):
	pass

func handle_hit():
	health_stat.health -= 20
	if health_stat.health <= 0:
		queue_free()
