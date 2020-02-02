extends Node


onready var viewport_right = $MainScreens/Screens/P2Screen/ViewportRight
onready var viewport_left = $MainScreens/Screens/P1Screen/ViewportLeft
onready var viewport_top = $MainScreens/Overworld/ViewportTop
onready var camera_right = $MainScreens/Screens/P2Screen/ViewportRight/CameraP2
onready var camera_left = $MainScreens/Screens/P1Screen/ViewportLeft/CameraP1
onready var world =  $world

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_left.world_2d = viewport_right.world_2d
	viewport_top.world_2d = viewport_right.world_2d
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
