extends CharacterBody2D

signal exp_changed(exp:int,exptonext:int)
signal levelup(level:int)
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


var lastdir = "DOWN"

signal hp_changed (hp:int , maxhp:int)

var knife_damage = 10
var knife_pierce = 0

var maxhp =100
var spd= 200
var hlt = 100
var level :=1
var exp :=0
var exptonext = 10
var invincible :=false
@onready var shootpoint: Node2D = $shootpoint
@onready var pickup_radi: Area2D = $pickup_radi

var exptonext_base = 2
var exptonext_increase = 1.4

var shootpoint_distance = 50
@export var knife_scn :PackedScene
@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.timeout.connect(_throwknife)
	exptonext = exptonext_base
	sprite_2d.modulate = Color(0.941, 0.341, 0.0, 1.0)
	hp_changed.emit(hlt,maxhp)
func _physics_process(_delta: float) -> void:
	var input := Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = input*spd
	move_and_slide()
	#print(hlt)
	_update_animation(input)
	print(input)
	
	
	
func _update_animation(input:Vector2):
	var moving := input.length() >0.1
	if moving:
		lastdir = _dir_name(input)
		sprite_2d.flip_h = input.x <0
	sprite_2d.play(("RUN_" if moving else "IDLE_") + lastdir)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
func _dir_name(v):
	var ax = abs(v.x)
	var ay = abs(v.y)
	if ay < ax * 0.4:
		return "RIGHT"
	if ax < ay *0.4:
		return "DOWN" if v.y >0 else "UP"
	return "DOWN_RIGHT" if v.y > 0 else "UP_RIGHT"
	
func _throwknife() -> void:
	var dir = (get_global_mouse_position() - global_position).normalized()
	
	var knife = knife_scn.instantiate()
	
	knife.direction = dir
	#print(global_position ,knife.global_position)
	knife.damage = knife_damage
	knife.pierce = knife_pierce
	get_tree().current_scene.add_child(knife)
	knife.global_position = global_position + dir*shootpoint_distance
	
func Damage(amt):
	if invincible:
		return
	hlt-=amt
	hp_changed.emit(hlt,maxhp)
	invincible = true
	modulate = Color(0.719, 0.034, 0.0, 1.0)
	await get_tree().create_timer(0.5).timeout
	invincible = false
	modulate = Color.WHITE
	if hlt <=0:
		get_tree().reload_current_scene()


func _on_pickup_radi_area_entered(area: Area2D) -> void:
	if area.is_in_group("exp_orb"):
		area.target = self
		
func add_exp(amt):
	print("expadded", amt)
	exp += amt
	
	while exp >= exptonext:
		exp-=exptonext
		level += 1
		exptonext = int(exptonext_base*pow(exptonext_increase, level-1))
		levelup.emit(level)
		exp_changed.emit(exp,exptonext)

func apply_upgrade(id:String):
	match id:
		"damage": knife_damage += 1 
		"firerate": timer.wait_time = max(0.1, timer.wait_time*0.85)
		"pierce":knife_pierce +=1
		"speed" : spd+=20
		"heal":
			hlt+= 30 
			hp_changed.emit(hlt,maxhp)
