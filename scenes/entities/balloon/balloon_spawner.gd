class_name BalloonSpawner extends Node2D

@export var balloon: PackedScene
@export var rise_limit: Node2D

var spawn_count: int = 0
var spawn_limit: int = 4

func spawn(is_correct: bool, has_gravity: bool = false, speed: float = 100):
	var new_balloon = balloon.instantiate()
	add_child(new_balloon)
	new_balloon.global_position = global_position
	new_balloon.spawn(is_correct, has_gravity)
	new_balloon.speed = speed
	if rise_limit:
		new_balloon.rise_limit = rise_limit

func spawn_timer():
	await get_tree().create_timer(0.5).timeout
	spawn(false, true, 200)
	spawn_count += 1
	if spawn_count < spawn_limit:
		spawn_timer()
