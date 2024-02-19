extends CharacterBody2D
class_name Player

@export var speed: int = 100

@onready var health_stat = $Health
@onready var weapon: Weapon = $Weapon
@onready var team = $Team

func _ready() -> void:
	weapon.initialize(team.team)


func get_input() -> Vector2:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	return Vector2(horizontal, vertical)


func _physics_process(_delta: float) -> void: 
	var direction = get_input()
	if direction.length() > 0:
		set_velocity(direction.normalized() * speed)
	else:
		set_velocity(Vector2.ZERO)
	move_and_slide()
	
	look_at(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("shoot"):
		weapon.shoot()


func get_team() -> int:
	return team.team

func handle_hit():
	health_stat.health -= 20
