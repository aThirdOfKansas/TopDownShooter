extends CharacterBody2D

@export var speed: int = 100
@export var Bullet: PackedScene
@onready var end_of_gun: Node = $EndOfGun

func _ready() -> void: #runs once on creation
	#motion_mode = MOTION_MODE_FLOATING
	pass


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
		shoot()


func shoot():
	var bullet_instance = Bullet.instantiate()
	add_child(bullet_instance)
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = bullet_instance.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
