extends Camera2D


var target = null

export(String, "p1", "p2") var id = "p1"

func _physics_process(_delta):
	if target:
		position = target.position
