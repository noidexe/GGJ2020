extends Control

export(PackedScene) var next_scene

func _ready():
	$ProgressBar.max_value = $preloader.get_child_count()
	
	for child in $preloader.get_children():
		if child is Particles2D:
			child.emitting = true
			$ProgressBar.value += 1
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
	#goto title
	yield(get_tree().create_timer(1.0),"timeout")
	get_tree().change_scene_to(next_scene)
	pass # Replace with function body.
