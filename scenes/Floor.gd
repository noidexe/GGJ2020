extends Area2D

func _on_Floor_area_entered(area):
	if area.is_in_group("player_bullets"):
		area.floor_death()
	pass # Replace with function body.
