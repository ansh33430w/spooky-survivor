extends Node2D

@export var monsterscn :PackedScene
var spawn_rad = 500
var spawn_interval = 1.0

@export var player:Node2D 
@onready var hud: CanvasLayer = $HUD

@onready var timer: Timer = $Timer
@onready var levelup_ui: CanvasLayer = $levelupUI


func _ready() -> void:
	player.levelup.connect(levelup_ui.show_choice)
	levelup_ui.chosen.connect(player.apply_upgrade)
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawnmonster)
	player.hp_changed.connect(hud.sethp)
	player.levelup.connect(hud.setlevel)
	hud.sethp(player.hlt,player.maxhp)
	hud.setlevel(player.level)
	
func spawnmonster():
	if player == null:
		return
		
	var angle:=randf()*TAU
	var monster = monsterscn.instantiate()
	monster.global_position = player.global_position  + Vector2.RIGHT.rotated(angle) * spawn_rad
	add_child(monster)
