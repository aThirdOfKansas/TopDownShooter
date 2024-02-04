extends Node2D


signal state_changed(new_state)

enum State {
	PATROL,
	ENGAGE
}

@onready var player_detection_zone = $PlayerDetectionZone

var current_state = State.PATROL: set = set_state
var actor = null
var player: Player = null
var weapon: Weapon = null


func initialize(init_actor, init_weapon: Weapon):
	actor = init_actor
	weapon = init_weapon


func _physics_process(_delta):
	match current_state:
		State.PATROL:
			pass
		State.ENGAGE:
			if player != null and weapon != null:
				actor.rotation = actor.global_position.direction_to(player.global_position).angle()
				weapon.shoot()
			else:
				printerr("Enemy in ENGAGE state without player or weapon")
		_:
			printerr("Enemy in unhandled state.")


func set_state(new_state: State):
	if new_state == current_state:
		return
	
	current_state = new_state
	emit_signal("state_changed", current_state)


func _on_player_detection_zone_body_entered(body):
	if body.is_in_group("player"):
		set_state(State.ENGAGE)
		player = body
