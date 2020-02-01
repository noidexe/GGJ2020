extends Area2D

export(float) var velocity = 1000
export(int) var damage = 10
export(Vector2) var direction = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(global_position + direction)
	pass # Replace with function body.

func _physics_process(delta):
	position += direction * velocity * delta

func kill():
	#spawn explosion
	queue_free()



func _on_death_timer_timeout():
	queue_free()
	pass # Replace with function body.
