extends CharacterBody2D


var spd= 80
var hlt = 20
var atkdmg = 10
var hitframe = 4
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var detect: Area2D = $Detect

var target :Node2D

var dead := false
var hurt:=false
var playerinrange :=false

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	print(target)
	animated_sprite_2d.frame_changed.connect(framechanged)
	animated_sprite_2d.animation_finished.connect(animation_finished)
	hitbox.monitoring = false
	animated_sprite_2d.play("RUN")
func _physics_process(delta: float) -> void:
	if dead or target == null:
		return
	if hurt:
		velocity = Vector2.ZERO
		move_and_slide()
		print(global_position)
		return
	var to_player :=  target.global_position - global_position
	animated_sprite_2d.flip_h = to_player.x < 0
	if  not playerinrange:
		detect.rotation =  to_player.angle()
		hitbox.rotation = to_player.angle()
	#print(playerinrange,velocity)
	
	if playerinrange:
		velocity = Vector2.ZERO
		if animated_sprite_2d.animation != "ATK":
			animated_sprite_2d.play("ATK")
	else:
		velocity= to_player.normalized()*spd
		if animated_sprite_2d.animation!= "RUN":
			animated_sprite_2d.play("RUN")
	move_and_slide()

func damage(amt):
	if dead:
		return
	hlt -=amt
		
	if hlt <=0 :
		dead = true
		playerinrange=false
		velocity = Vector2.ZERO
		hitbox.set_deferred("monitoring",false)
		$CollisionShape2D.set_deferred("disabled",true
		)
		$hurtbox/CollisionShape2D.set_deferred("disabled",true)
		animated_sprite_2d.play("DEATH")
	else:
		hurt = true
		animated_sprite_2d.play("HURT")
		
		
		


func _on_detect_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		playerinrange = true
		

func _on_detect_area_exited(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		playerinrange = false
	
	
func framechanged():
	if dead or animated_sprite_2d.animation!="ATK" or animated_sprite_2d.frame!= hitframe :
		return
		
	hitbox.monitoring  = true
	await get_tree().physics_frame
	await get_tree().physics_frame
	if not dead :
		for area in hitbox.get_overlapping_areas():
			if area.get_parent().is_in_group("player"):
				target.Damage(atkdmg)
	hitbox.set_deferred("monitoring",false)
		
		
func animation_finished():
	match animated_sprite_2d.animation:
		"DEATH" : 
			queue_free()
		"HURT" :
			hurt= false
			animated_sprite_2d.play("RUN")
			
			
				
		
