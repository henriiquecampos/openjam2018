extends CanvasLayer

export (NodePath) var ammo_node
var text = ""
var current_ammo = 0
var total_ammo = 0

func _ready():
	ammo_node = get_node(ammo_node)
	
	for c in ammo_node.get_children():
		c.connect("tree_exited", self, "_on_can_queue_free")
	
	total_ammo = ammo_node.get_child_count()
	text = $control/ammo.text
	$control/ammo.text = text.format({"current": current_ammo, "total": total_ammo })
	
func _on_can_queue_free():
	current_ammo += 1
	$control/ammo.text = text.format({"current": current_ammo, "total": total_ammo})

func _on_gun_shooted():
	current_ammo -= 1
	$control/ammo.text = text.format({"current": current_ammo, "total": total_ammo})
