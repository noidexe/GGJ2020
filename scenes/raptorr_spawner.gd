extends Position2D

var raptor_scene = preload("res://scenes/Raptorr.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var new_raptor = raptor_scene.instance()
	get_parent().add_child(new_raptor)
	new_raptor.global_position = global_position
	pass # Replace with function body.