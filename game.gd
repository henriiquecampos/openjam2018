extends Node

func _on_level_00_player_died():
	print("game over")
	
	get_tree().reload_current_scene()

func _on_brain_player_damaged():
	get_tree().reload_current_scene()
