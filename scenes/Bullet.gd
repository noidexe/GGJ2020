extends Area2D

export(PackedScene) var explosion_scene

export(float) var velocity = 1000
export(int) var damage = 10
export(Vector2) var direction = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready():
	look_at(global_position + direction)
	pass # Replace with function body.

func _physics_process(delta):
	position += direction * velocity * delta

func kill():
	_spawn_explosion(explosion_scene)
	queue_free()


func _spawn_explosion(scene):
	var explosion = scene.instance()
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	explosion.scale *= 0.5

func _on_death_timer_timeout():
	queue_free()
	pass # Replace with function body.
