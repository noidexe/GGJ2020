extends KinematicBody2D

class_name Player


const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)
const SLOPE_SLIDE_STOP = 25.0
const WALK_SPEED = 250 # pixels/sec
const JUMP_SPEED = 680
const SIDING_CHANGE_SPEED = 10
const BULLET_VELOCITY = 1000
const SHOOT_TIME_SHOW_WEAPON = 0.2

var linear_vel = Vector2()
var shoot_time = 99999 # time since last shot

var anim = ""

export(String, "p1", "p2") var id = "p1"
var repair_target = null

# cache the sprite here for fast access (we will set scale to flip it often)
onready var sprite = $Sprite

func _ready():
	if id == "p1":
		sprite.modulate = Color(3.0,1,1)
	if id == "p2":
		sprite.modulate = Color(1,1,3.0)


func _physics_process(delta):
	# Increment counters
	shoot_time += delta

	### MOVEMENT ###

	# Apply gravity
	linear_vel += delta * GRAVITY_VEC
	# Move and slide
	linear_vel = move_and_slide(linear_vel, FLOOR_NORMAL, SLOPE_SLIDE_STOP)
	# Detect if we are on floor - only works if called *after* move_and_slide
	var on_floor = is_on_floor()

	### CONTROL ###

	# Horizontal movement
	var target_speed = 0
	if Input.is_action_pressed(id + "_move_left"):
		target_speed -= 1
	if Input.is_action_pressed(id + "_move_right"):
		target_speed += 1

	target_speed *= WALK_SPEED
	linear_vel.x = target_speed #lerp(linear_vel.x, target_speed, 0.1)

	# Jumping
	if on_floor and Input.is_action_just_pressed(id + "_jump"):
		linear_vel.y = -JUMP_SPEED
	
	if Input.is_action_just_pressed(id + "_hit"):
		_hit(repair_target)


	### ANIMATION ###

	var new_anim = "idle"

	if on_floor:
		if linear_vel.x < -SIDING_CHANGE_SPEED:
			sprite.scale.x = -1
			new_anim = "run"

		if linear_vel.x > SIDING_CHANGE_SPEED:
			sprite.scale.x = 1
			new_anim = "run"
	else:
		# We want the character to immediately change facing side when the player
		# tries to change direction, during air control.
		# This allows for example the player to shoot quickly left then right.
		if Input.is_action_pressed(id + "_move_left") and not Input.is_action_pressed(id + "_move_right"):
			sprite.scale.x = -1
		if Input.is_action_pressed(id + "_move_right") and not Input.is_action_pressed(id + "_move_left"):
			sprite.scale.x = 1

		if linear_vel.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"

	if shoot_time < SHOOT_TIME_SHOW_WEAPON:
		new_anim += "_weapon"

	if new_anim != anim:
		anim = new_anim
		($Anim as AnimationPlayer).play(anim)


func _hit(target):
	if target != null and !target.is_working:
		target.hit()
