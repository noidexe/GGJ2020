extends Camera2D


var target = null

export(String, "p1", "p2") var id = "p1"

func _physics_process(_delta):
	if target:
		position = target.position

func _ready():
	$Tween.interpolate_property(self, "zoom", 3.0 * Vector2.ONE, 1.0 * Vector2.ONE,3.0, Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
