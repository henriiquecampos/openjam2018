extends KinematicBody2D

const GRAVITY = 500
var velocity = Vector2(0, 0)

func _ready():
	set_physics_process(false)

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		set_physics_process(true)

func _physics_process(delta):
	
	move_and_collide(velocity * delta)
	
	if velocity.y >= 500:
		return
	velocity.y += GRAVITY * delta
	