extends Area2D

export(int) var total_hp = 100
export(int) var total_shields = 100
export(int) var shield_recharge_amount = 25

export(PackedScene) var slash_bullet
export(PackedScene) var gun_bullet
export(PackedScene) var missile_bullet


onready var anims = $anims
onready var force_fiield_anim = $force_field/anims
onready var hp_bar = $sprite/hp
onready var shield_bar = $sprite/shields

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
	if area.is_in_group("enemies"):
		area.melee_range = true
	elif area.is_in_group("enemy_bullets"):
		hit(area.damage)

func hit(damage):
	if shield_bar.value > 0:
		shield_bar.value -= damage
	else:
		hp_bar.value -= damage
		if !is_dead and hp_bar.value <= 0:
			is_dead = true
			_to_game_over()
	


func _to_game_over():
	yield(get_tree().create_timer(3.0), "timeout")
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	pass

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

