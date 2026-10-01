extends Area2D

var speed = 600
var dmg =  10
var duratin = 1.5
var pierce = 2
var direction :Vector2 = Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	
	get_tree().create_timer(duratin).timeout.connect(queue_free)
	
func _physics_process(delta: float) -> void:
	position += direction*speed*delta
	



func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damage"):
		body.damage(dmg)
		if pierce < 0:
			pierce-= 1
		elif pierce ==0:
			queue_free()
