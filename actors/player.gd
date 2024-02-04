extends CharacterBody2D
class_name Player

signal player_fired_bullet(bullet, position, direction)

@export var speed: int = 100

@onready var health_stat = $Health
@onready var weapon = $Weapon

func _ready() -> void:
	weapon.connect("weapon_fired", Callable(self, "shoot"))


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


func shoot(bullet_instance, location: Vector2, direction: Vector2):
	emit_signal("player_fired_bullet", bullet_instance, location, direction)


func handle_hit():
	health_stat.health -= 20
