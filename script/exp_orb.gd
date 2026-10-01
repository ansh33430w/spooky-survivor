extends Area2D


var value = 1

var speed = 500.0

var target :Node2D = null

func _physics_process(delta: float) -> void:
	if target:
		print("orb moving")
		global_position = global_position.move_toward(target.global_position,speed*delta)
		if global_position.distance_to(target.global_position)< 10:
			if target.has_method("getexp"):
				target.addexp(value)
			queue_free()
