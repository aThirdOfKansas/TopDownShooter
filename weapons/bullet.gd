extends Area2D
class_name Bullet

@export var speed: int = 5
@onready var despawn_timer: Node = $DespawnTimer

var direction := Vector2.ZERO
var team: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	despawn_timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(dir: Vector2):
	direction = dir
	rotation += direction.angle()


func _on_despawn_timer_timeout():
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.has_method("handle_hit"):
		if body.has_method("get_team") and body.get_team() != team:
			body.handle_hit()
		queue_free()
