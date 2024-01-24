extends CharacterBody2D

@export var speed: int = 100
@export var acceleration: float = 0.0
@export var friction: float = 0.0


func _ready() -> void: #runs once on creation
	#motion_mode = MOTION_MODE_FLOATING
	pass


func get_input() -> Vector2:
	var horizontal := Input.get_axis("left", "right")
	var vertical := Input.get_axis("up", "down")
	return Vector2(horizontal, vertical)


func _physics_process(_delta: float) -> void: #checks every frame
	var direction = get_input()
	if direction.length() > 0:
		set_velocity(direction.normalized() * speed)
	else:
		set_velocity(Vector2.ZERO)
	move_and_slide()
	
	look_at(get_global_mouse_position())
