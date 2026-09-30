extends Node2D

@export var monsterscn :PackedScene
var spawn_rad = 500
var spawn_interval = 1.0

@export var player:Node2D 

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawnmonster)
	
	
func spawnmonster():
	if player == null:
		return
		
	var angle:=randf()*TAU
	var monster = monsterscn.instantiate()
	monster.global_position = player.global_position  + Vector2.RIGHT.rotated(angle) * spawn_rad
	add_child(monster)
