extends Position2D

var raptor_scene = preload("res://scenes/Raptorr.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	$raptorr_spawn_rate.wait_time = rand_range(10,20)
	var new_raptor = raptor_scene.instance()
	get_parent().add_child(new_raptor)
	new_raptor.global_position = global_position
	new_raptor.target_position_x = global_position.x + 250
	pass # Replace with function body.
