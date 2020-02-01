extends "res://scenes/Bullet.gd"

func _on_target_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if !enemies.empty():
		var target = enemies[ randi() % enemies.size() ]
		direction = (target.global_position + Vector2.RIGHT * rand_range(-200,200) - global_position).normalized()
		look_at(global_position + direction)
	pass # Replace with function body.
