extends "res://scenes/Bullet.gd"

export(PackedScene) var floor_explosion_scene

func _on_target_timer_timeout():
	var enemies = get_tree().get_nodes_in_group("enemies")
	if !enemies.empty():
		var target = enemies[ randi() % enemies.size() ]
		direction = (target.global_position + Vector2.RIGHT * rand_range(-100,100) - global_position).normalized()
		look_at(global_position + direction)
	pass # Replace with function body.

func floor_death():
	_spawn_explosion(floor_explosion_scene)
	queue_free()
