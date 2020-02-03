extends Area2D
class_name ConsoleBox

enum SYSTEMS { GUN, MISSILES, SLASH, FORCE_FIELD }

export(SYSTEMS) var weapon_type = SYSTEMS.FORCE_FIELD
export(float) var fill_time = 3.0
export(int) var life_ticks_min = 3
export(int) var life_ticks_max = 10
export(int) var hits_to_repair = 5

var hp
var is_working = true

signal broken(me)
signal repaired(me)
signal triggered(me)

onready var timer = $trigger_timer
onready var trigger_bar = $sprite/trigger_bar
onready var repair_bar = $sprite/repair_bar
onready var smoke = $smoke

func _ready():
	randomize()
	trigger_bar.setup(fill_time)
	trigger_bar.is_working = is_working
	timer.wait_time = fill_time
	repair_bar.setup(hits_to_repair)
	timer.start()
	
	_restart()
	pass

func _process(_delta):
	trigger_bar.value = fill_time - timer.time_left

func _on_body_entered(body):
	if body is Player:
		body.repair_target = self
	pass # Replace with function body.


func _on_body_exited(body):
	if body is Player:
		body.repair_target = null
	pass # Replace with function body.


func _on_trigger_timer_timeout():
	emit_signal("triggered", self)
	pass # Replace with function body.

func _break():
	$sfx.play()
	is_working = false
	timer.paused = true
	trigger_bar.is_working = is_working
	repair_bar.value = 0
	smoke.emitting = true
	emit_signal("broken", self)
	pass
	
func _restart():
	$sfx_repaired.play()
	smoke.emitting = false
	hp = rand_range(life_ticks_min, life_ticks_max)
	is_working = true
	timer.paused = false
	trigger_bar.is_working = true
	run()
	yield(get_tree().create_timer(0.2), "timeout")
	repair_bar.value = 0
	pass

func run():
	while(is_working):
		hp -= 1
		if hp <= 0:
			_break()
		yield(get_tree().create_timer(1.0), "timeout")

func hit():
	if !is_working:
		repair_bar.value += 1
		if repair_bar.value >= hits_to_repair:
			emit_signal("repaired", self)
			_restart()

func _on_ConsoleBox_input_event(_viewport, event, _shape_idx):
	if !is_working and event.is_action_pressed("click"):
		repair_bar.value += 1
		if repair_bar.value >= hits_to_repair:
			emit_signal("repaired", self)
			_restart()
	pass # Replace with function body.

func kill():
	emit_signal("repaired", self)
	#spawn_explotion()
	queue_free()
