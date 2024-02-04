extends Node2D

@onready var bullet_manager = $BulletManager
@onready var player: Player = $Player

func _ready():
	player.connect("player_fired_bullet", Callable(bullet_manager, "handle_bullet_spawned"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
