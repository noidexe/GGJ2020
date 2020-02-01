extends Node2D


var target = null setget _set_target

func _ready():
	set_process(false)

func _process(_delta):
	look_at(target.global_position)
	pass
	
func _set_target(node):
	target = node
	look_at(target.global_position)
	set_process(true)
