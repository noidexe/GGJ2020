extends Area2D

export(int) var pace = 1
export(int) var stride = 10
export(int) var total_hp = 100
export(float) var aggressiveness = 0.2 #0 = no attacks 1 = always attacks
export(int) var melee_dmg = 30
export(int) var ranged_dmg = 10

export(PackedScene) var bullet_scene

onready var advance_timer = $advance_timer
onready var bullet_spawner = $bullet_spawner

onready var motion_anims = $motion_anims
onready var damage_anims = $damage_anims

var hp
var melee_range = false

var ultrazort = null
var target_position_x

# Called when the node enters the scene tree for the first time.
func _ready():
	target_position_x = position.x
	ultrazort = get_tree().get_nodes_in_group("ultrazort")[0]
	hp = rand_range(0.3, 1.0) * total_hp
	scale *= 0.5 + 0.5 * inverse_lerp(0.3, total_hp, hp)
	advance_timer.wait_time = pace
	advance_timer.start()
	pass # Replace with function body.
	
func _on_advance_timer_timeout():
	_advance()
	_roll_for_attack()
	pass # Replace with function body.

func _advance():
	motion_anims.play("advance")
	if melee_range:
		return
	target_position_x += stride
	$tween.interpolate_property(self, "position:x", position.x, target_position_x,0.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$tween.start()
	pass
	
func _roll_for_attack():
	if melee_range:
		_melee_attack()
		return
	elif rand_range(0,1) < aggressiveness:
		_ranged_attack()
		return
	pass

func _melee_attack():
	ultrazort.hit(melee_dmg)
	pass
	
func _ranged_attack():
	var new_bullet = bullet_scene.instance()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = bullet_spawner.global_position
	pass

func _on_Raptorr_area_entered(area):
	if hp <= 0:
		return
	if area.is_in_group("player_bullets"):
		hit(area.damage)
		area.kill()
	elif area.is_in_group("ultrazort"):
		melee_range = true
	pass # Replace with function body.

func hit(damage):
	hp -= damage
	damage_anims.play("damage")
	if hp <= 0:
		advance_timer.stop()
		damage_anims.play("die")
