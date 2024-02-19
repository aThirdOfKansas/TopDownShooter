extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func handle_bullet_spawned(bullet: Bullet, team: int, pos: Vector2, direction: Vector2):
	add_child(bullet)
	bullet.team = team
	bullet.global_position = pos
	bullet.set_direction(direction)
