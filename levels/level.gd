extends Node2D

signal player_died

func _on_lava_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_died")


func _on_void_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_died")


func _on_boss_pit_body_exited(body):
	$boss/brain.initialize()
	$template_actor/gun.ammo -= $ammos.get_child_count()