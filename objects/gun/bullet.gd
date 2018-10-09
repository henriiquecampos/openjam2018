extends KinematicBody2D

var speed = 1000

func _physics_process(delta):
	move_and_collide(Vector2(speed * delta, 0))
		
func _on_area_2d_body_entered(body):
	queue_free()


func _on_area_2d_area_entered(area):
	if not area.name == "boss":
		queue_free()
