extends Area2D

export(int) var total_hp = 100
export(int) var total_shields = 100
export(int) var shield_recharge_amount = 25

export(PackedScene) var slash_bullet
export(PackedScene) var gun_bullet
export(PackedScene) var missile_bullet

signal mortally_wound()
signal damaged()

onready var anims = $anims
onready var force_fiield_anim = $force_field/anims
onready var hp_bar = $hp
onready var shield_bar = $shields

onready var bullet_spawnpoint = $bullet_spawnpoint
onready var missile_spawnpoint = $missile_spawnpoint
onready var slash_spawnpoint = $slash_spawnpoint

var is_dead = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hp_bar.max_value = total_hp
	hp_bar.value = hp_bar.max_value
	shield_bar.max_value = total_shields
	shield_bar.value = round(0.5 * shield_bar.max_value)
	get_tree().call_group("boxes", "connect", "triggered", self, "_on_box_triggered")
# warning-ignore:return_value_discarded
	connect("area_entered", self, "_on_area_entered")
	pass # Replace with function body.


func _on_area_entered(area:Node):
	#if area.is_in_group("enemies"):
	#	area.melee_range = true
	if area.is_in_group("enemy_bullets"):
		hit(area.damage)
		area.kill()

func hit(damage):
	if is_dead:
		return
	if shield_bar.value > 0:
		shield_bar.value -= damage
		force_fiield_anim.play("flash")
	else:
		hp_bar.value -= damage
		emit_signal("damaged")
		anims.play("take_damage")
		if !is_dead and hp_bar.value <= 0:
			is_dead = true
			_to_game_over()
	


func _to_game_over():
	emit_signal("mortally_wound")
	get_tree().call_group("boxes", "disconnect", "triggered", self, "_on_box_triggered")
	get_tree().call_group("boxes", "kill")
	disconnect("area_entered", self, "_on_area_entered")
	anims.play("gameover")
	yield(anims, "animation_finished")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://levels/GameOver.tscn")
	pass

func _spawn_explosion():
	var explosion = preload("res://scenes/Explosion.tscn").instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position + Vector2(rand_range(-50,50), rand_range(-100,100))
	explosion.scale *= rand_range(0.25, 0.75)

func _on_box_triggered(box):
	match box.weapon_type:
		ConsoleBox.SYSTEMS.FORCE_FIELD:
			shield_bar.value += shield_recharge_amount
			pass
		ConsoleBox.SYSTEMS.GUN:
			anims.queue("gun")
			pass
		ConsoleBox.SYSTEMS.SLASH:
			anims.queue("slash")
			pass
		ConsoleBox.SYSTEMS.MISSILES:
			anims.queue("missile")
			pass
	pass


func _spawn_gun():
	var new_bullet = gun_bullet.instance()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = bullet_spawnpoint.global_position
	pass

func _spawn_slash():
	var new_bullet = slash_bullet.instance()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = slash_spawnpoint.global_position
	pass

func _spawn_missile():
	var new_bullet = missile_bullet.instance()
	get_parent().add_child(new_bullet)
	new_bullet.global_position = missile_spawnpoint.global_position + Vector2.RIGHT * rand_range(-25,25)
	pass

