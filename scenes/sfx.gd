extends AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0
	play()
	pass # Replace with function body.


func _on_sfx_finished():
	queue_free()
	pass # Replace with function body.
