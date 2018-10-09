extends Area2D

func _on_gun_pickup_body_entered(body):
	if body.is_in_group("player"):
		body.get_node("gun").visible = true
	queue_free()