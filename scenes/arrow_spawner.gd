extends Position2D

export(PackedScene) var arrow_scene

var arrows = {}

func _ready():
	get_tree().call_group("boxes", "connect", "broken", self, "_on_broken")
	get_tree().call_group("boxes", "connect", "repaired", self, "_on_repaired")

func _on_broken(box):
	_add_arrow(box)
	
func _on_repaired(box):
	_remove_arrow(box)
	
func _add_arrow(box):
	var new_arrow = arrow_scene.instance()
	add_child(new_arrow)
	new_arrow.target = box
	if not arrows.has(box):
		arrows[box] = new_arrow
	pass

func _remove_arrow(box):
	if arrows.has(box):
		arrows[box].queue_free()
		arrows.erase(box)
	pass
