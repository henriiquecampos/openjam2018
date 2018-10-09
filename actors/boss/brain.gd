extends Node

var health = 40

signal player_damaged

enum MOVES {MOVE_TOP, MOVE_BOT, MOVE_LEFT, MOVE_RIGHT, MOVE_CENTER,
	 STOMP, DASH_LEFT, DASH_RIGHT, WANDER, WAKE}

var previous_move = null
onready var animator = $"../animator"
onready var tween = $"../tween"
onready var boss = get_parent()
export (NodePath) var boss_pit

func _ready():
	randomize()
	boss_pit = get_node(boss_pit)

func initialize():
	animator.play("wake")
	previous_move = WAKE
	yield(animator, "animation_finished")
	next_behavior()
	
func _on_boss_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_damaged")
#		get_tree().quit()
	elif body.is_in_group("bullet"):
		body.queue_free()
		health -= 1
		if health <= 0:
			get_tree().quit()
			
func next_behavior():
	var moves = []
	match previous_move:
		MOVE_TOP:
			moves.append(STOMP)
			moves.append(MOVE_LEFT)
			moves.append(MOVE_RIGHT)
			moves.append(MOVE_CENTER)
		MOVE_BOT:
			moves.append(MOVE_TOP)
			moves.append(MOVE_LEFT)
			moves.append(MOVE_RIGHT)
			moves.append(MOVE_CENTER)
		MOVE_LEFT:
			moves.append(MOVE_TOP)
			moves.append(MOVE_CENTER)
			moves.append(DASH_RIGHT)
			moves.append(WANDER)
		MOVE_RIGHT:
			moves.append(MOVE_TOP)
			moves.append(MOVE_CENTER)
			moves.append(DASH_LEFT)
			moves.append(WANDER)
		MOVE_CENTER:
			moves.append(MOVE_TOP)
			moves.append(MOVE_BOT)
			moves.append(MOVE_RIGHT)
			moves.append(MOVE_LEFT)
		DASH_LEFT:
			moves.append(MOVE_TOP)
			moves.append(MOVE_BOT)
			moves.append(MOVE_RIGHT)
			moves.append(MOVE_CENTER)
			moves.append(DASH_RIGHT)
			moves.append(WANDER)
		DASH_RIGHT:
			moves.append(MOVE_TOP)
			moves.append(MOVE_BOT)
			moves.append(MOVE_LEFT)
			moves.append(MOVE_CENTER)
			moves.append(DASH_LEFT)
			moves.append(WANDER)
		STOMP:
			moves.append(MOVE_RIGHT)
			moves.append(MOVE_LEFT)
		WANDER:
			moves.append(MOVE_TOP)
			moves.append(MOVE_BOT)
		WAKE:
			moves.append(DASH_LEFT)
			moves.append(MOVE_TOP)
	
	var next_move = moves[randi()%moves.size()]
	$timer.start()
	yield($timer, "timeout")
	
	match next_move:
			MOVE_TOP:
				tween.interpolate_property(boss, "global_position", boss.global_position, 
					boss_pit.get_node("top").global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
				tween.start()
				yield(tween, "tween_completed")
			MOVE_BOT:
				tween.interpolate_property(boss, "global_position", boss.global_position, 
					boss_pit.get_node("bot").global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
				tween.start()
				yield(tween, "tween_completed")
			MOVE_LEFT:
				tween.interpolate_property(boss, "global_position", boss.global_position, 
					boss_pit.get_node("left").global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
				tween.start()
				yield(tween, "tween_completed")
			MOVE_RIGHT:
				tween.interpolate_property(boss, "global_position", boss.global_position, 
					boss_pit.get_node("right").global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
				tween.start()
				yield(tween, "tween_completed")
			MOVE_CENTER:
				tween.interpolate_property(boss, "global_position", boss.global_position, 
					boss_pit.get_node("mid").global_position, 1.0, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
				tween.start()
				yield(tween, "tween_completed")
			DASH_RIGHT:
				animator.play("dash_right")
				yield(animator, "animation_finished")
			DASH_LEFT:
				animator.play("dash_left")
				yield(animator, "animation_finished")
			STOMP:
				animator.play("squash")
				yield(animator, "animation_finished")
			WANDER:
				match previous_move:
					MOVE_LEFT:
						animator.play("wander")
					DASH_LEFT:
						animator.play("wander")
					MOVE_RIGHT:
						animator.play_backwards("wander")
					DASH_RIGHT:
						animator.play_backwards("wander")
				yield(animator, "animation_finished")
				
	previous_move = next_move
	
	next_behavior()


func _on_tween_tween_started(object, key):
	print(key)
