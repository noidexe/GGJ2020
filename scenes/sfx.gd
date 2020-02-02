extends AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	frame = 0
	play()
	yield(self, "animation_finished")
	queue_free()
	pass # Replace with function body.
