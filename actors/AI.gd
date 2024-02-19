extends Node2D


signal state_changed(new_state)

enum State {
	EMPTY,
	PATROL,
	ENGAGE
}

@onready var patrol_timer: Timer = $PatrolTimer

var current_state = State.EMPTY: set = set_state
var actor: CharacterBody2D = null
var target: CharacterBody2D = null
var weapon: Weapon = null
var team: int = -1

#PATROL State
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false
var actor_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	set_state(State.PATROL)


func initialize(init_actor: CharacterBody2D, init_weapon: Weapon, init_team: int):
	actor = init_actor
	weapon = init_weapon
	team = init_team

# Shortest angle lerp to stop enemy from doing 360s
#static func lerp_angle(from, to, weight):
#	return from + _short_angle_dist(from, to) * weight
#
#static func _short_angle_dist(from, to):
#	var max_angle = PI * 2
#	var difference = fmod(to - from, max_angle)
#	return fmod(2 * difference, max_angle) - difference


func _physics_process(_delta):
	match current_state:
		State.PATROL:
			if not patrol_location_reached:
				actor.set_velocity(actor_velocity)
				actor.move_and_slide()
				actor.rotate_toward(patrol_location)
				if actor.global_position.distance_to(patrol_location) < 5:
					patrol_location_reached = true
					actor_velocity = Vector2.ZERO
					patrol_timer.start()
		State.ENGAGE:
			if target != null and weapon != null:
				actor.rotate_toward(target.global_position)
				var angle_to_target = actor.global_position.direction_to(target.global_position).angle()
				var shoot_angle = abs(rad_to_deg(angle_to_target) - fmod(actor.rotation_degrees, 360))
				if shoot_angle < 30 or shoot_angle > 330:
					weapon.shoot()
			else:
				printerr("Enemy in ENGAGE state without target or weapon")
		_:
			printerr("Enemy in unhandled state.")


func set_state(new_state: State):
	if new_state == current_state:
		return
	
	if new_state == State.PATROL:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_patrol_timer_timeout():
	var patrol_range = 50
	var random_x = randf_range(-patrol_range, patrol_range)
	var random_y = randf_range(-patrol_range, patrol_range)
	patrol_location = Vector2(random_x, random_y) + origin
	patrol_location_reached = false
	actor_velocity = actor.velocity_toward(patrol_location)


func _on_detection_zone_body_entered(body):
	if body.has_method("get_team") and body.get_team() != team:
		set_state(State.ENGAGE)
		target = body


func _on_detection_zone_body_exited(body):
	if target and body == target:
		set_state(State.PATROL)
		target = null
