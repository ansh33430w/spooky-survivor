extends CharacterBody2D


var spd= 200
var hlt = 100

var invincible :=false
@onready var shootpoint: Node2D = $shootpoint

var shootpoint_distance = 100
@export var knife_scn :PackedScene
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_throwknife)


func _physics_process(delta: float) -> void:
	var input := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input*spd
	move_and_slide()
	print(hlt)
func _throwknife() -> void:
	var dir = (get_global_mouse_position() - global_position).normalized()
	shootpoint.position = dir * shootpoint_distance
	var knife = knife_scn.instantiate()
	knife.global_position = shootpoint.global_position
	knife.direction = dir
	#print(global_position ,knife.global_position)
	get_tree().current_scene.add_child(knife)
	
	
	
func Damage(amt):
	if invincible:
		return
	hlt-=amt
	invincible = true
	modulate = Color(0.719, 0.034, 0.0, 1.0)
	await get_tree().create_timer(0.5).timeout
	modulate = Color.WHITE
	if hlt <=0:
		get_tree().reload_current_scene()
