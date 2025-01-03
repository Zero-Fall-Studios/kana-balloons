extends Node2D

@export var balloon_spawners: Array[BalloonSpawner]

func _ready() -> void:
	print("Study")

	GameManager.balloon_popped.connect(on_balloon_popped)
	next_balloon()

func next_balloon() -> void:
	GameManager.choose_next_character()
	var random_balloon_spawner = balloon_spawners.pick_random()
	random_balloon_spawner.spawn(true, true)

func on_balloon_popped(correct: bool) -> void:
	print("Balloon popped: ", correct)
	next_balloon()
