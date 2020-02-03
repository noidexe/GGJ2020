extends Node


onready var viewport_right = $MainScreens/Screens/P2Screen/ViewportRight
onready var viewport_left = $MainScreens/Screens/P1Screen/ViewportLeft
onready var viewport_top = $MainScreens/Overworld/ViewportTop
onready var camera_right = $MainScreens/Screens/P2Screen/ViewportRight/CameraP2
onready var camera_left = $MainScreens/Screens/P1Screen/ViewportLeft/CameraP1
onready var world =  $MainScreens/Screens/P2Screen/ViewportRight/world

export(Color) var clear_color

# Called when the node enters the scene tree for the first time.
func _ready():
	score.time = 0
	$MainScreens/Screens/noise.hide()
	$MainScreens/Screens/noise2.hide()
	VisualServer.set_default_clear_color(clear_color)
	viewport_left.world_2d = viewport_right.world_2d
	viewport_top.world_2d = viewport_right.world_2d
	yield(get_tree(), "idle_frame")
	get_tree().call_group("ultrazort", "connect", "mortally_wound", self, "_on_gameover")
	get_tree().call_group("ultrazort", "connect", "damaged", self, "_on_ultrazort_damaged")
	pass # Replace with function body.

func _on_gameover():
	set_physics_process(false)
	$music.stop()
	$music.stream = preload("res://audio/Game Over.wav")
	$music.play()
	$MainScreens/Screens/P1Screen.hide()
	$MainScreens/Screens/P2Screen.hide()
	$MainScreens/Screens/noise.show()
	$MainScreens/Screens/noise2.show()

func _on_ultrazort_damaged():
	var offset
	for _i in range(30):
		offset = Vector2(rand_range(-20,20), rand_range(-20,20))
		camera_left.offset = offset
		camera_right.offset = offset
		yield(get_tree(), "idle_frame")
	camera_left.offset = Vector2.ZERO
	camera_right.offset = Vector2.ZERO
	pass

func _physics_process(delta):
	score.time += delta
