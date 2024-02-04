extends CharacterBody2D

var health: int = 100

func _physics_process(delta):
	pass

func handle_hit():
	health -= 20
	if health <= 0:
		queue_free()
