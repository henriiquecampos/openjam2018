extends Node2D

signal shooted
var ammo = 0

export (PackedScene) var bullet
export (NodePath) var ammo_node

onready var aim = $right

func _ready():
	ammo_node = get_node(ammo_node)
	ammo = ammo_node.get_child_count()
	
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
		
func shoot():
	if not visible:
		return
	if ammo < 1:
		return
	
	var b = bullet.instance()
	b.global_position = aim.global_position
	if aim == $left:
		b.speed *= -1
	get_tree().root.add_child(b)
	ammo -= 1
	emit_signal("shooted")

func _on_template_actor_direction_changed(new_direction):
	if new_direction >= 0:
		aim = $right
		$pivot.scale.x = 1
	else:
		aim = $left
		$pivot.scale.x = -1